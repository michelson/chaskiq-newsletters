require "nokogiri"

module Postino
  class LinkRenamer

    def self.convert(html, url_prefix="")
      content = Nokogiri::HTML(html)
      content.css("a").each do |link|
        val = link.attributes["href"].value
        link.attributes["href"].value = self.rename_link(val, url_prefix)
      end
      content.to_html
    end

    def self.rename_link(value, url_prefix)
      "#{url_prefix}" + value
    end

  end
end
