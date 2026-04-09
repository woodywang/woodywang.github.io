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
# Strategy: fix everything in post_render by directly modifying the HTML output.
# The I18n_Headers canonical (the last one) is always correct for the current
# language, so we use it as the source of truth.

module PolyglotSeoFix
  def self.fix_output(page_or_doc)
    content = page_or_doc.output
    return unless content

    site = page_or_doc.site
    return unless site.respond_to?(:active_lang) && site.respond_to?(:default_lang)

    canonical_re = /<link rel="canonical" href="([^"]*)"\s*\/?>/
    canonicals = content.scan(canonical_re).map(&:first)
    return if canonicals.empty?

    if site.active_lang != site.default_lang
      # For non-default language pages:
      # The last canonical (from I18n_Headers) has the correct language-prefixed URL.
      # The first canonical (from jekyll-seo-tag) is missing the language prefix.
      correct_url = canonicals.last

      # Replace the first canonical with the correct URL, remove all subsequent ones
      first_replaced = false
      content = content.gsub(canonical_re) do
        if first_replaced
          ""
        else
          first_replaced = true
          %(<link rel="canonical" href="#{correct_url}" />)
        end
      end

      # Fix og:url to match the correct canonical
      content = content.gsub(
        /(<meta property="og:url" content=")[^"]*(")/
      ) { "#{$1}#{correct_url}#{$2}" }

      # Fix JSON-LD "url" field to match the correct canonical
      content = content.gsub(
        /("url"\s*:\s*")[^"]*(")/
      ) { "#{$1}#{correct_url}#{$2}" }

      # Fix x-default hreflang to always point to the default language version.
      # Use the zh-CN hreflang URL as the source of truth for x-default.
      default_lang = Regexp.escape(site.default_lang)
      zh_match = content.match(/hreflang="#{default_lang}" href="([^"]*)"/)
      if zh_match
        content = content.gsub(
          /(<link rel="alternate" hreflang="x-default" href=")[^"]*("\s*\/?>)/
        ) { "#{$1}#{zh_match[1]}#{$2}" }
      end
    else
      # For default language pages: just remove duplicate canonicals (keep first)
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
end

Jekyll::Hooks.register :pages, :post_render do |page|
  PolyglotSeoFix.fix_output(page)
end

Jekyll::Hooks.register :documents, :post_render do |doc|
  PolyglotSeoFix.fix_output(doc)
end
