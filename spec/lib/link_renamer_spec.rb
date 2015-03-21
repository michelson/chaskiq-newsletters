require 'rails_helper'

module Postino
  RSpec.describe LinkRenamer, type: :model do

    let(:html) { "<p><a href='http://google.com'></p>"}
    let(:renamer){  Postino::LinkRenamer }

    it "will rename links" do
      data = renamer.convert(html, "AAA")
      expect(data).to include("AAA")
    end

  end
end
