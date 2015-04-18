require 'rails_helper'

def send_data(params)
  @request.env['RAW_POST_DATA'] = params.to_json
  post :create
end

module Chaskiq
  RSpec.describe HooksController, type: :controller do

    routes { Chaskiq::Engine.routes }
    let(:list){ FactoryGirl.create(:chaskiq_list) }
    let(:subscriber){
      list.create_subscriber FactoryGirl.attributes_for(:chaskiq_subscriber)
    }
    let(:campaign){ FactoryGirl.create(:chaskiq_campaign, list: list) }

    let(:metric){
      FactoryGirl.create(:chaskiq_metric, campaign: campaign, trackable: subscriber)
    }
    let(:bounce_sns){
       {"Message" => {
             "notificationType"=>"Bounce",
             "bounce"=>{
                "bounceType"=>"Permanent",
                "bounceSubType"=> "General",
                "bouncedRecipients"=>[
                   {
                      "emailAddress"=>"#{subscriber.email}"
                   },
                   {
                      "emailAddress"=>"recipient2@example.com"
                   }
                ],
                "timestamp"=>"2012-05-25T14:59:38.237-07:00",
                "feedbackId"=>"00000137860315fd-869464a4-8680-4114-98d3-716fe35851f9-000000"
             },
             "mail"=>{
                "timestamp"=>"2012-05-25T14:59:38.237-07:00",
                "messageId"=>"00000137860315fd-34208509-5b74-41f3-95c5-22c1edc3c924-000000",
                "source"=>"#{campaign.from_email}",
                "destination"=>[
                   "recipient1@example.com",
                   "recipient2@example.com",
                   "recipient3@example.com",
                   "recipient4@example.com"
                ]
            }
          }.to_json
        }
    }

    let(:complaint_sns){
      {"Message" => {
          "notificationType"=>"Complaint",
          "complaint"=>{
             "complainedRecipients"=>[
                {
                   "emailAddress"=>"#{subscriber.email}"
                }
             ],
             "timestamp"=>"2012-05-25T14:59:38.613-07:00",
             "feedbackId"=>"0000013786031775-fea503bc-7497-49e1-881b-a0379bb037d3-000000"
          },
          "mail"=>{
             "timestamp"=>"2012-05-25T14:59:38.613-07:00",
             "messageId"=>"0000013786031775-163e3910-53eb-4c8e-a04a-f29debf88a84-000000",
             "source"=>"#{campaign.from_email}",
             "destination"=>[
                "recipient1@example.com",
                "recipient2@example.com",
                "recipient3@example.com",
                "recipient4@example.com"
             ]
          }
        }.to_json
      }
    }


    it "will set a bounce" do
      allow(Chaskiq::Metric).to receive(:find_by).and_return(metric)
      campaign
      response = send_data(bounce_sns)
      expect(response.status).to be == 200
      expect(campaign.metrics.bounces.size).to be == 1
    end

    it "will set a spam metrc and unsubscribe user" do
      allow(Chaskiq::Metric).to receive(:find_by).and_return(metric)

      campaign
      response = send_data(complaint_sns)
      expect(response.status).to be == 200
      expect(campaign.metrics.spams.size).to be == 1
      expect(subscriber.subscriptions.first.reload).to be_unsubscribed
    end

  end
end
