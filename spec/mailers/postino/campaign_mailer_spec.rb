require "rails_helper"

module Postino
  RSpec.describe CampaignMailer, type: :mailer do

    let(:template){ FactoryGirl.create(:postino_template) }
    let(:list){ FactoryGirl.create(:postino_list) }
    let(:subscriber){  FactoryGirl.create(:postino_subscriber, list: list) }
    let(:campaign){ FactoryGirl.create(:postino_campaign, template: template, list: list) }
    let(:template_html){ "<p>{{name}}</p>"}
    let(:premailer_template){"<p>{{name}} {{last_name}} {{email}} {{campaign_url}} {{campaign_subscribe}} {{campaign_unsubscribe}}this is the template</p>"}

    it "should deliver newsletter" do
      #allow_any_instance_of(Premailer).to receive(:to_inline_css).and_return("<p></p>")
      allow_any_instance_of(Postino::Campaign).to receive(:premailer).and_return(premailer_template)

      allow_any_instance_of(Postino::Campaign).to receive(:html_content).and_return(template_html)
      Postino::CampaignMailer.newsletter(campaign, subscriber).deliver_now
      expect(last_email.subject).to_not be_blank
      expect(last_email.body).to include(subscriber.name)
      expect(last_email.body).to include("subscribers/new")
      expect(last_email.body).to include("/delete")
      #last_email.body.parts.each{|o| o.body.should_not be_blank }
    end


  end
end
