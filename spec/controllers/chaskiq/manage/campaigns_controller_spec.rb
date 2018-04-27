require 'rails_helper'

module Chaskiq
  RSpec.describe Manage::CampaignsController, type: :controller do
    routes { Chaskiq::Engine.routes }

    let(:campaign){ FactoryBot.create(:chaskiq_campaign) }

    before do
      campaign
    end

    it "will render index" do
      response = get :index
      expect(response).to render_template(:index)
      expect(assigns(:campaigns).map(&:id)).to eq(Chaskiq::Campaign.all.map(&:id))
    end

    it "will render show" do
      response = get :show , params: {id: campaign.id}
      expect(response).to render_template(:show)
      expect(assigns(:campaign)).to eq(campaign)
    end
  end
end
