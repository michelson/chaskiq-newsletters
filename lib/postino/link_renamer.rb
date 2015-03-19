require "nokogiri"

module Postino
  class LinkRenamer

    def self.convert(html)
      content = Nokogiri::HTML(html)
      content.css("a").each do |link|
        link.attributes["href"].value = self.rename_link(link.attributes["href"].value)
      end
      content.to_html
    end

    def self.rename_link(value)
      "AAAA" + value
    end

  end
end
