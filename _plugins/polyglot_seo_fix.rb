# Fixes canonical URL and x-default hreflang issues when using
# jekyll-polyglot with jekyll-seo-tag.
#
# Problems solved:
# 1. jekyll-seo-tag generates canonical/og:url without the language prefix
#    for non-default language pages (e.g. /en/ pages get canonical pointing to /)
# 2. Both jekyll-seo-tag and polyglot's I18n_Headers output canonical tags,
#    creating duplicates
# 3. Polyglot sets x-default hreflang to the current page's language instead
#    of consistently pointing to the default language version

module PolyglotSeoFix
  # Set correct canonical_url for non-default language pages so that
  # jekyll-seo-tag generates the right canonical and og:url
  def self.fix_canonical(page_or_doc)
    site = page_or_doc.site
    return unless site.respond_to?(:active_lang) && site.respond_to?(:default_lang)
    return if site.active_lang == site.default_lang

    lang_prefix = "/#{site.active_lang}"
    url = page_or_doc.url
    page_or_doc.data["canonical_url"] = "#{site.config['url']}#{lang_prefix}#{url}"
  end

  # Post-process rendered HTML to:
  # - Remove duplicate canonical tags (keep the first one from jekyll-seo-tag)
  # - Fix x-default hreflang to always point to the default language version
  def self.fix_output(page_or_doc)
    content = page_or_doc.output
    return unless content

    site = page_or_doc.site
    return unless site.respond_to?(:active_lang) && site.respond_to?(:default_lang)

    # Remove duplicate canonical tags (keep first, remove subsequent)
    canonical_re = /<link rel="canonical" href="[^"]*"\s*\/?>/
    matches = content.scan(canonical_re)
    if matches.length > 1
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

    # Fix x-default hreflang to point to the default language version
    if site.active_lang != site.default_lang
      page_url = page_or_doc.url
      default_href = "#{site.config['url']}#{page_url}"
      content = content.gsub(
        /(<link rel="alternate" hreflang="x-default" href=")[^"]*("\s*\/?>)/
      ) do
        "#{$1}#{default_href}#{$2}"
      end
    end

    page_or_doc.output = content
  end
end

Jekyll::Hooks.register :pages, :pre_render do |page|
  PolyglotSeoFix.fix_canonical(page)
end

Jekyll::Hooks.register :documents, :pre_render do |doc|
  PolyglotSeoFix.fix_canonical(doc)
end

Jekyll::Hooks.register :pages, :post_render do |page|
  PolyglotSeoFix.fix_output(page)
end

Jekyll::Hooks.register :documents, :post_render do |doc|
  PolyglotSeoFix.fix_output(doc)
end
