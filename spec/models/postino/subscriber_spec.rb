require 'rails_helper'

module Postino
  RSpec.describe Subscriber, type: :model do
    it{ should belong_to :list }
    it{ should have_many :metrics }
    it{ should have_one :campaign }


    describe "states" do
      let(:subscriber){ FactoryGirl.create(:postino_subscriber)}

      it "will set passive state" do
        expect(subscriber).to be_passive
      end

      it "will notify susbscrition" do
        expect(subscriber).to receive(:notify_subscription).once
        subscriber.suscribe
        expect(subscriber).to be_subscribed
      end

      it "will notify un susbscrition" do
        expect(subscriber).to receive(:notify_unsubscription).once
        subscriber.unsuscribe
        expect(subscriber).to be_unsubscribed
      end

      it "encode decode email" do

         expect(subscriber.email).to_not be == subscriber.encoded_name
      end

    end
  end
end
