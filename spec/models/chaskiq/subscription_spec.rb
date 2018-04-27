require 'rails_helper'

module Chaskiq
  RSpec.describe Subscription, type: :model do
    it{ should belong_to :list }
    it{ should belong_to :subscriber }
    it{ should have_many :campaigns }

    let(:template){ FactoryBot.create(:chaskiq_template) }
    let(:list){ FactoryBot.create(:chaskiq_list) }
    let(:subscriber){
      list.create_subscriber FactoryBot.attributes_for(:chaskiq_subscriber)
    }
    let(:campaign){ FactoryBot.create(:chaskiq_campaign, template: template, list: list) }

    it "will set passive state" do
      subscriber
      expect(campaign.subscriptions.passive.size).to be == 1
    end

    it "will notify susbscrition" do
      sub = list.subscriptions.first
      #expect(sub).to receive(:notify_subscription).once
      list.subscribe(subscriber)
      expect(list.subscriptions.subscribed.map(&:subscriber)).to include subscriber
    end

    it "will notify un susbscrition" do
      #expect(subscriber).to receive(:notify_unsubscription).once
      list.unsubscribe(subscriber)
      expect(list.subscriptions.unsubscribed.map(&:subscriber)).to include subscriber
    end


  end
end
