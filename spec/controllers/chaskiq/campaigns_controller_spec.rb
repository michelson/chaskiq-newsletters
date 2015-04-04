require 'rails_helper'

module Chaskiq
  RSpec.describe CampaignsController, type: :controller do

    render_views
    routes { Chaskiq::Engine.routes }
    let(:list){ FactoryGirl.create(:chaskiq_list) }
    let(:subscriber){
      list.create_subscriber FactoryGirl.attributes_for(:chaskiq_subscriber)
    }
    let(:campaign){ FactoryGirl.create(:chaskiq_campaign, list: list) }


    it "will show campaign!" do
      campaign
      response = get("show", id: campaign.id)
      expect(response.status).to be == 200
      expect(response.body).to include "subscribe"
      expect(response.body).to include campaign.name
    end
  end
end
