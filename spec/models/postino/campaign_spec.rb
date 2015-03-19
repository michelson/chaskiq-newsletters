require 'rails_helper'

module Postino
  RSpec.describe Campaign, type: :model do

    it{ should have_many :attachments }
    #it{ should have_one :campaign_template }
    #it{ should have_one(:template).through(:campaign_template) }
    it{ should belong_to :list }
    it{ should belong_to :template }

    let(:template){ FactoryGirl.create(:postino_template) }

    describe "creation" do
      it "will create a pending campaign by default" do
        @c = FactoryGirl.create(:postino_campaign)
        expect(@c).to_not be_sent
      end
    end

    context "recipient step" do

      it "will validate the prescence of a list  when setup_step!" do
      end

      it "will associate a list when setup_step!" do
      end

    end

    context "setup step" do

      it "will validate basic info" do
      end

      it "will set step if valid" do
      end

    end

    context "template step" do
      before do
        @c = FactoryGirl.create(:postino_campaign)
      end

      it "will set step if valid" do
        @c.template = template
        @c.save
        expect(@c.template).to be == template
      end

    end

  end
end
