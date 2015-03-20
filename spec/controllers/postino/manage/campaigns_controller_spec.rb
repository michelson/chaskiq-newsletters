require 'rails_helper'

module Postino
  RSpec.describe Manage::CampaignsController, type: :controller do
    routes { Postino::Engine.routes }

    let(:campaign){ FactoryGirl.create(:postino_campaign) }

    before do
      campaign
    end

    it "will render index" do
      response = get :index
      expect(response).to render_template(:index)
      expect(assigns(:campaigns)).to eq(Postino::Campaign.all)
    end

    it "will render show" do
      response = get :show , id: campaign.id
      expect(response).to render_template(:show)
      expect(assigns(:campaign)).to eq(campaign)
    end
  end
end
