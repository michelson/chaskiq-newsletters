require 'rails_helper'

module Postino
  RSpec.describe TracksController, type: :controller do

    routes { Postino::Engine.routes }
    let(:list){ FactoryGirl.create(:postino_list) }
    let(:subscriber){ FactoryGirl.create(:postino_subscriber, list: list) }
    let(:campaign){ FactoryGirl.create(:postino_campaign, list: list) }

    %w[click open bounce spam].each do |action|
      it "will track an #{action}" do
        campaign
        response = get(action , campaign_id: campaign.id, id: subscriber.id)
        expect(response.status).to be == 200
        expect(campaign.metrics.send(action.pluralize).size).to be == 1
        expect(response.content_type).to be == "image/gif"
      end
    end

  end
end
