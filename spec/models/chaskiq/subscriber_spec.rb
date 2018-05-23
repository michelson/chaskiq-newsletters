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


    describe "options" do

      let(:list){
        list = Chaskiq::List.new
        list.name = "new one"
        list.save
        list
      }

      it "will permit creation on accessors" do
        opt = {name: Faker::Name.name, 
          email: Faker::Internet.email, 
          last_name: Faker::Name.name,
          company: Faker::Company.bs,
          country: Faker::Nation.nationality }

        list.subscribers.create(opt)
        expect(list.subscribers.size).to be == 1 
        expect(list.subscribers.first.company).to be_present
        expect(list.subscribers.first.country).to be_present
      end

      it "will permit creation from an options hash key" do
        opt = {name: Faker::Name.name, 
          email: Faker::Internet.email, 
          last_name: Faker::Name.name,
          options: {
            company: Faker::Company.bs,
            country: Faker::Nation.nationality            
            }
          }

        list.subscribers.create(opt)
        expect(list.subscribers.size).to be == 1 
        expect(list.subscribers.first.company).to be_present
        expect(list.subscribers.first.country).to be_present
      end


      it "will permit creation on additional options hash key and accessible from it" do
        opt = {name: Faker::Name.name, 
          email: Faker::Internet.email, 
          last_name: Faker::Name.name,
          options: {
            interplanetary_galaxy: Faker::Nation.nationality            
            }
          }

        list.subscribers.create(opt)
        expect(list.subscribers.size).to be == 1 
        expect(list.subscribers.first.company).to be_blank
        expect(list.subscribers.first.country).to be_blank
        expect(list.subscribers.first.options[:interplanetary_galaxy]).to be_present
      end

    end
  end
end
