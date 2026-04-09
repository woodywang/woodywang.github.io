# Fixes canonical URL, og:url, and x-default hreflang issues when using
# jekyll-polyglot with jekyll-seo-tag.
#
# Problems solved:
# 1. jekyll-seo-tag generates canonical/og:url without the language prefix
#    for non-default language pages (e.g. /en/ pages get canonical pointing to /)
# 2. Both jekyll-seo-tag and polyglot's I18n_Headers output canonical tags,
#    creating duplicates
# 3. Polyglot sets x-default hreflang to the current page's language instead
#    of consistently pointing to the default language version
#
# Strategy:
# - post_render: fix canonical duplicates, og:url, and JSON-LD url
#   (these are correct after polyglot's URL rewriting adds the lang prefix)
# - post_write: fix x-default in the final HTML files on disk, AFTER
#   polyglot's URL rewriting has run (which incorrectly adds lang prefix
#   to x-default)

module PolyglotSeoFix
  # Fix canonical and og:url in rendered output (before polyglot URL rewriting)
  def self.fix_output(page_or_doc)
    content = page_or_doc.output
    return unless content

    site = page_or_doc.site
    return unless site.respond_to?(:active_lang) && site.respond_to?(:default_lang)

    canonical_re = /<link rel="canonical" href="([^"]*)"\s*\/?>/
    canonicals = content.scan(canonical_re).map(&:first)
    return if canonicals.empty?

    if site.active_lang != site.default_lang
      # The last canonical (from I18n_Headers) gets the correct URL after
      # polyglot's URL rewriting. Keep it, remove the first one (from seo-tag).
      # At this point both are base URLs; polyglot will add /en/ to the kept one.
      correct_url = canonicals.last

      first_replaced = false
      content = content.gsub(canonical_re) do
        if first_replaced
          ""
        else
          first_replaced = true
          %(<link rel="canonical" href="#{correct_url}" />)
        end
      end

      # Fix og:url (polyglot will add the lang prefix after this hook)
      content = content.gsub(
        /(<meta property="og:url" content=")[^"]*(")/
      ) { "#{$1}#{correct_url}#{$2}" }

      # Fix JSON-LD "url" field
      content = content.gsub(
        /("url"\s*:\s*")[^"]*(")/
      ) { "#{$1}#{correct_url}#{$2}" }
    else
      # For default language: just remove duplicate canonicals (keep first)
      if canonicals.length > 1
        first_found = false
        content = content.gsub(canonical_re) do |match|
          if first_found
            ""
          else
            first_found = true
            match
          end
        end
      end
    end

    page_or_doc.output = content
  end

  # Fix x-default in final HTML files AFTER polyglot's URL rewriting.
  # Polyglot incorrectly adds the language prefix to x-default URLs.
  # x-default should always point to the default language (zh-CN) version.
  def self.fix_xdefault_in_files(site)
    return unless site.respond_to?(:active_lang) && site.respond_to?(:default_lang)
    return if site.active_lang == site.default_lang

    lang_dir = File.join(site.dest, site.active_lang)
    return unless Dir.exist?(lang_dir)

    Dir.glob(File.join(lang_dir, "**", "*.html")).each do |file|
      content = File.read(file)
      default_lang_escaped = Regexp.escape(site.default_lang)
      zh_url = content[/hreflang="#{default_lang_escaped}" href="([^"]*)"/, 1]
      xd_url = content[/hreflang="x-default" href="([^"]*)"/, 1]

      if zh_url && xd_url && zh_url != xd_url
        content = content.sub(
          "hreflang=\"x-default\" href=\"#{xd_url}\"",
          "hreflang=\"x-default\" href=\"#{zh_url}\""
        )
        File.write(file, content)
      end
    end
  end
end

Jekyll::Hooks.register :pages, :post_render do |page|
  PolyglotSeoFix.fix_output(page)
end

Jekyll::Hooks.register :documents, :post_render do |doc|
  PolyglotSeoFix.fix_output(doc)
end

Jekyll::Hooks.register :site, :post_write do |site|
  PolyglotSeoFix.fix_xdefault_in_files(site)
end
