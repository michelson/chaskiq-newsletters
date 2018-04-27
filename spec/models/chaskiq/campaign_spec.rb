require 'rails_helper'

module Chaskiq
  RSpec.describe Campaign, type: :model do

    include ActiveJob::TestHelper

    it{ should have_many :attachments }
    it{ should have_many :metrics }
    #it{ should have_one :campaign_template }
    #it{ should have_one(:template).through(:campaign_template) }
    it{ should belong_to :list }
    it{ should have_many(:subscribers).through(:list) }
    it{ should belong_to :template }

    let(:html_content){
      "<p>hola {{name}} {{email}}</p> <a href='http://google.com'>google</a>"
    }
    let(:template){ FactoryBot.create(:chaskiq_template, body: html_content ) }
    let(:list){ FactoryBot.create(:chaskiq_list) }
    let(:subscriber){
      #list.create_subscriber(subscriber)
      list.create_subscriber FactoryBot.attributes_for(:chaskiq_subscriber)
    }
    let(:subscription){
      subscriber.subscriptions.first
    }
    let(:campaign){ FactoryBot.create(:chaskiq_campaign, template: template) }
    let(:premailer_template){"<p>{{name}} {{last_name}} {{email}} {{campaign_url}} {{campaign_subscribe}} {{campaign_unsubscribe}}this is the template</p>"}

    describe "creation" do
      it "will create a pending campaign by default" do
        @c = FactoryBot.create(:chaskiq_campaign)
        expect(@c).to_not be_sent
        allow_any_instance_of(Chaskiq::Campaign).to receive(:premailer).and_return(premailer_template)
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
          list.create_subscriber FactoryBot.attributes_for(:chaskiq_subscriber)
        end

        @c = FactoryBot.create(:chaskiq_campaign, template: template, list: list)

        allow(@c).to receive(:premailer).and_return("<p>hi</p>")
        allow_any_instance_of(Chaskiq::Campaign).to receive(:apply_premailer).and_return(true)
      end

      it "will prepare mail to" do
        expect(@c.prepare_mail_to(subscription)).to be_an_instance_of(ActionMailer::MessageDelivery)
      end

      it "will prepare mail to can send inline" do
        reset_email
        @c.prepare_mail_to(subscription).deliver_now
        expect(ActionMailer::Base.deliveries.size).to be 1
      end

      it "will send newsletter jobs for each subscriber" do
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 0
        Chaskiq::MailSenderJob.perform_now(@c)
        #expect(@c.metrics.deliveries.size).to be == 10
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 10
      end

      it "will send newsletter jobs for each subscriber" do
        @c.subscriptions.first.unsubscribe!
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 0
        Chaskiq::MailSenderJob.perform_now(@c)
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 9
      end

      it "will send newsletter for dispatch" do
        @c.subscriptions.first.unsubscribe!
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 0
        @c.send_newsletter
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 1
      end

    end

    context "template compilation" do

      it "will render subscriber attributes" do
        campaign.template = template
        campaign.save
        expect(campaign.html_content).to be == template.body
        allow_any_instance_of(Chaskiq::Campaign).to receive(:premailer).and_return("{{name}}")
        expect(campaign.mustache_template_for(subscriber)).to include(subscriber.name)
      end

      it "will render subscriber and compile links with host ?r=link" do
        campaign.template = template
        campaign.save
        allow_any_instance_of(Chaskiq::Campaign).to receive(:premailer).and_return("<a href='http://google.com'>google</a>")
        expect(campaign.compiled_template_for(subscriber)).to include("?r=http://google.com")
        expect(campaign.compiled_template_for(subscriber)).to include(campaign.host)
      end

    end


    context "clone campaign" do
      it "should clone record" do
        c = campaign.clone_newsletter
        c.save
        expect(c.id).to_not be == campaign.id
        expect(c.template).to be == campaign.template
        expect(c.list).to be == campaign.list
        expect(c.subscribers).to be == campaign.subscribers
      end

      it "rename" do
        c = campaign.clone_newsletter
        c.save
        expect(c.name).to_not be == campaign.name
        expect(c.name).to include("copy")
      end

    end

  end
end
