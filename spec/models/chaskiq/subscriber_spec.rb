require 'rails_helper'
require 'urlcrypt'
module Chaskiq
  RSpec.describe Subscriber, type: :model do
    it{ should have_many :subscriptions }
    it{ should have_many(:lists).through(:subscriptions) }
    it{ should have_many :metrics }
    it{ should have_many(:campaigns).through(:lists) }


    describe "states" do
      let(:subscriber){ FactoryBot.create(:chaskiq_subscriber)}

      it "will set passive state" do
        #expect(subscriber).to be_passive
      end

      it "will notify susbscrition" do
        #expect(subscriber).to receive(:notify_subscription).once
        #subscriber.suscribe
        #expect(subscriber).to be_subscribed
      end

      it "will notify un susbscrition" do
        #expect(subscriber).to receive(:notify_unsubscription).once
        #subscriber.unsuscribe
        #expect(subscriber).to be_unsubscribed
      end

      it "encode decode email" do
        expect(subscriber.email).to_not be == subscriber.encoded_id
        expect(URLcrypt.encode(subscriber.email)).to be == subscriber.encoded_id
      end

    end
  end
end
