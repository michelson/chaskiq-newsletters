require "rails_helper"

module Postino
  RSpec.describe CampaignMailer, type: :mailer do

    let(:template){ FactoryGirl.create(:postino_template) }
    let(:list){ FactoryGirl.create(:postino_list) }
    let(:subscriber){  FactoryGirl.create(:postino_subscriber, list: list) }
    let(:campaign){ FactoryGirl.create(:postino_campaign, template: template, list: list) }
    let(:template_html){ "<p>{{name}}</p>"}

    it "should deliver newsletter" do
      allow_any_instance_of(Postino::Campaign).to receive(:html_content).and_return(template_html)
      Postino::CampaignMailer.newsletter(campaign, subscriber).deliver_now
      last_email.subject.should_not be_blank
      expect(last_email.body).to include(subscriber.name)
      #last_email.body.parts.each{|o| o.body.should_not be_blank }
    end


  end
end
