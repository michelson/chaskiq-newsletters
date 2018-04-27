require 'rails_helper'

module Chaskiq
  RSpec.describe CampaignsController, type: :controller do

    render_views
    routes { Chaskiq::Engine.routes }
    let(:list){ FactoryBot.create(:chaskiq_list) }
    let(:subscriber){
      list.create_subscriber FactoryBot.attributes_for(:chaskiq_subscriber)
    }
    let(:campaign){ FactoryBot.create(:chaskiq_campaign, list: list) }

    it "will show campaign!" do
      campaign
      response = get("show", params: {id: campaign.id})
      expect(response.status).to be == 200
      expect(response.body).to include "subscribe"
      expect(response.body).to include campaign.name
    end
  end
end
