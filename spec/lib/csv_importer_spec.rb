require 'rails_helper'

module Chaskiq
  RSpec.describe CsvImporter, type: :model do


    let(:importer){  Chaskiq::CsvImporter.new }

    it "will initialize" do
      expect(importer).to be_an_instance_of Chaskiq::CsvImporter
    end

    it "will import data" do
      data = importer.import("spec/fixtures/csv_example.csv")
      expect(data.class).to be == Array
      expect(data.size).to be 3
      expect(data.first.size).to be 3
    end

  end
end
