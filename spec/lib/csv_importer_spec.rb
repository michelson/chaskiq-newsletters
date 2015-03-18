require 'rails_helper'

module Postino
  RSpec.describe CsvImporter, type: :model do


    let(:importer){  Postino::CsvImporter.new }

    it "will initialize" do
      expect(importer).to be_an_instance_of Postino::CsvImporter
    end

    it "will import data" do
      data = importer.import("spec/fixtures/csv_example.csv")
      expect(data.class).to be == Array
      expect(data.size).to be 3
      expect(data.first.size).to be 3
    end

  end
end
