require 'rails_helper'

module Postino
  RSpec.describe Campaign, type: :model do

    it{ should have_many :attachments }
    it{ should have_many :metrics }
    #it{ should have_one :campaign_template }
    #it{ should have_one(:template).through(:campaign_template) }
    it{ should belong_to :list }
    it{ should belong_to :template }

    let(:template){ FactoryGirl.create(:postino_template) }
    let(:list){ FactoryGirl.create(:postino_list) }

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

      it "will copy template" do
        @c.template = template
        @c.save
        expect(@c.html_content).to be == template.body
      end


      it "will copy template on creation" do
        @c = FactoryGirl.create(:postino_campaign, template: template)
        expect(@c.html_content).to be == template.body
      end

    end

    context "send newsletter" do
      before do

        10.times do
          FactoryGirl.create(:postino_subscriber, list: list)
        end

        @c = FactoryGirl.create(:postino_campaign, template: template, list: list)

      end

      it "send newsletter" do
        allow_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).and_return(true)
        expect(Postino::CampaignMailer).to receive(:newsletter).exactly(10).times.and_return(ActionMailer::MessageDelivery.new(1,2))
        @c.send_newsletter
      end

    end

  end
end
