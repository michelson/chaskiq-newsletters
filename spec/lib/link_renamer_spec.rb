require 'rails_helper'

module Postino
  RSpec.describe LinkRenamer, type: :model do

    let(:html) { "<p><a href='http://google.com'></p>"}
    let(:renamer){  Postino::LinkRenamer }

    it "will rename links" do
      data = renamer.convert(html, "AAA")
      expect(data).to include("AAA")
    end


    it "test_initialize_no_escape_attributes_option" do
      html = "<html> <body>
      <a id='google' href='http://google.com'>Google</a>
      <a id='noescape' href='{{link_url}}'>Link</a>
      </body> </html>"

      [:nokogiri].each do |adapter|
        pm = Premailer.new(html, :with_html_string => true, :adapter => adapter, :escape_url_attributes => false)
        pm.to_inline_css
        doc = pm.processed_doc
        expect( doc.at('#google')['href']).to be == 'http://google.com'
        expect(doc.at('#noescape')['href']).to be == '{{link_url}}'
      end
    end

  end
end
