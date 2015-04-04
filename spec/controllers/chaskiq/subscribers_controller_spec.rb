require 'rails_helper'

module Chaskiq
  RSpec.describe SubscribersController, type: :controller do
    render_views
    routes { Chaskiq::Engine.routes }
    let(:list){ FactoryGirl.create(:chaskiq_list) }
    let(:subscriber){
      list.create_subscriber FactoryGirl.attributes_for(:chaskiq_subscriber)
    }
    let(:campaign){ FactoryGirl.create(:chaskiq_campaign, list: list) }

    it "will show subscriber!" do
      campaign
      response = get("show", campaign_id: campaign.id, id: subscriber.encoded_id)
      expect(response.status).to be == 200
      expect(response.body).to include campaign.name
    end

    it "will subscribe subscribe!" do
      campaign
      response = post("create", campaign_id: campaign.id, subscriber: {name: "some subscriber", last_name: "subscriberson", email: "some@email.com"})
      expect(response.status).to be == 302
      expect(campaign.subscriptions.subscribed.size).to be == 1
    end

    it "will unsubscribe unsubscribe!" do
      campaign
      subscriber
      response = delete("destroy", campaign_id: campaign.id, id: subscriber.encoded_id )
      expect(response.status).to be == 302
      expect(list.subscriptions.unsubscribed.size).to be == 1
    end

    it "will update subscriber" do
      campaign
      subscriber
      response = delete("update", campaign_id: campaign.id, id: subscriber.encoded_id, subscriber: {name: "updated name"} )
      expect(response.status).to be == 302
      expect(subscriber.reload.name).to be == "updated name"
    end

  end
end
