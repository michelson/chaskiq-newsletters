require 'rails_helper'

module Postino
  RSpec.describe Campaign, type: :model do

    it{ should have_many :attachments }
    it{ should have_many :metrics }
    #it{ should have_one :campaign_template }
    #it{ should have_one(:template).through(:campaign_template) }
    it{ should belong_to :list }
    it{ should belong_to :template }

    let(:html_content){
      "<p>hola {{name}} {{email}}</p> <a href='http://google.com'>google</a>"
    }
    let(:template){ FactoryGirl.create(:postino_template, body: html_content ) }
    let(:list){ FactoryGirl.create(:postino_list) }
    let(:subscriber){ FactoryGirl.create(:postino_subscriber, list: list)}
    let(:campaign){ FactoryGirl.create(:postino_campaign, template: template) }

    describe "creation" do
      it "will create a pending campaign by default" do
        @c = FactoryGirl.create(:postino_campaign)
        expect(@c).to_not be_sent
      end
    end

    context "template step" do

      it "will copy template" do
        campaign.template = template
        campaign.save
        expect(campaign.html_content).to be == template.body
      end

      it "will copy template on creation" do
        expect(campaign.html_content).to be == template.body
      end

    end

    context "send newsletter" do
      before do

        10.times do
          FactoryGirl.create(:postino_subscriber, list: list)
        end

        @c = FactoryGirl.create(:postino_campaign, template: template, list: list)

      end

      it "will send newsletter & create deliver metrics" do
        allow_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).and_return(true)
        expect(Postino::CampaignMailer).to receive(:newsletter).exactly(10).times.and_return(ActionMailer::MessageDelivery.new(1,2))
        @c.send_newsletter
        expect(@c.metrics.deliveries.size).to be == 10
      end

    end

    context "template compilation" do

      it "will render subscriber attributes" do
        campaign.template = template
        campaign.save
        expect(campaign.html_content).to be == template.body
        expect(campaign.mustache_template_for(subscriber)).to_not be == template.body
        expect(campaign.mustache_template_for(subscriber)).to include(subscriber.name)
      end

      it "will render subscriber and compile links with host ?r=link" do
        campaign.template = template
        campaign.save
        expect(campaign.compiled_template_for(subscriber)).to include("?r=http://google.com")
        expect(campaign.compiled_template_for(subscriber)).to include(campaign.host)
      end

    end

  end
end
