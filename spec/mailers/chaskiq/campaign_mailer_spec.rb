require "rails_helper"

module Chaskiq
  RSpec.describe CampaignMailer, type: :mailer do

    let(:template){ FactoryGirl.create(:chaskiq_template) }
    let(:list){ FactoryGirl.create(:chaskiq_list) }
    let(:subscriber){  FactoryGirl.create(:chaskiq_subscriber, list: list) }
    let(:campaign){ FactoryGirl.create(:chaskiq_campaign, template: template, list: list) }
    let(:template_html){ "<p>{{name}}</p>"}
    let(:premailer_template){"<p>{{name}} {{last_name}} {{email}} {{campaign_url}} {{campaign_subscribe}} {{campaign_unsubscribe}}this is the template</p>"}

    it "should deliver newsletter" do
      #allow_any_instance_of(Premailer).to receive(:to_inline_css).and_return("<p></p>")
      allow_any_instance_of(Chaskiq::Campaign).to receive(:premailer).and_return(premailer_template)

      allow_any_instance_of(Chaskiq::Campaign).to receive(:html_content).and_return(template_html)
      Chaskiq::CampaignMailer.newsletter(campaign, subscriber).deliver_now
      expect(last_email.subject).to_not be_blank
      expect(last_email.body).to include(subscriber.name)
      expect(last_email.body).to include("subscribers/new")
      expect(last_email.body).to include("/delete")
      #last_email.body.parts.each{|o| o.body.should_not be_blank }
    end


  end
end
