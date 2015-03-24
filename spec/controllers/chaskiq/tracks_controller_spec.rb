require 'rails_helper'

module Chaskiq
  RSpec.describe TracksController, type: :controller do

    routes { Chaskiq::Engine.routes }
    let(:list){ FactoryGirl.create(:chaskiq_list) }
    let(:subscriber){ FactoryGirl.create(:chaskiq_subscriber, list: list) }
    let(:campaign){ FactoryGirl.create(:chaskiq_campaign, list: list) }

    %w[open bounce spam].each do |action|
      it "will track an #{action}" do
        campaign
        response = get(action , campaign_id: campaign.id, id: subscriber.encoded_id)
        expect(response.status).to be == 200
        expect(campaign.metrics.send(action.pluralize).size).to be == 1
        expect(response.content_type).to be == "image/gif"
      end
    end

    it "will track a click and redirect" do
      campaign
      response = get("click" , campaign_id: campaign.id, id: subscriber.encoded_id, r: "http://google.com")
      expect(response.status).to be == 302
      expect(campaign.metrics.clicks.size).to be == 1
      expect(response).to redirect_to "http://google.com"
    end

  end
end
