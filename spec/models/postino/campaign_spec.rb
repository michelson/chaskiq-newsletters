require 'rails_helper'

module Postino
  RSpec.describe Campaign, type: :model do

    it{ should have_many :attachments }
    it{ should have_one :campaign_template }
    it{ should have_one(:template).through(:campaign_template) }

    describe "creation" do
      it "will create a pending campaign by default" do
        @c = FactoryGirl.create(:postino_campaign)
        expect(@c).to_not be_sent
      end

    end
  end
end
