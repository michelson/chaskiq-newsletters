require 'rails_helper'

module Postino
  RSpec.describe List, type: :model do
    it{ should have_many :subscribers }
    it{ should have_many :campaigns }


    describe "creation" do
      let(:list){FactoryGirl.create(:postino_list)}

      it "will create a list" do
        data = list.import_csv("spec/fixtures/csv_example.csv")
        expect(list.subscribers.size).to be 3
      end

      it "will not save repeated data" do
        list.import_csv("spec/fixtures/csv_example.csv")
        list.import_csv("spec/fixtures/csv_example.csv")
        expect(list.subscribers.size).to be 3
      end

    end

  end
end
