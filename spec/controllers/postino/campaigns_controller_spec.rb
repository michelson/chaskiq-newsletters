require 'rails_helper'

module Postino
  RSpec.describe CampaignsController, type: :controller do

    render_views
    routes { Postino::Engine.routes }
    let(:list){ FactoryGirl.create(:postino_list) }
    let(:subscriber){ FactoryGirl.create(:postino_subscriber, list: list) }
    let(:campaign){ FactoryGirl.create(:postino_campaign, list: list) }


    it "will show campaign!" do
      campaign
      response = get("show", id: campaign.id)
      expect(response.status).to be == 200
      expect(response.body).to include "subscribe"
      expect(response.body).to include @campaign.name
    end
  end
end
