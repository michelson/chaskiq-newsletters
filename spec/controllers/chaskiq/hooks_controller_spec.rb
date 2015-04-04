require 'rails_helper'

#BOUNCES
=begin

 {
    "notificationType":"Bounce",
    "bounce":{
       "bounceType":"Permanent",
       "bounceSubType": "General",
       "bouncedRecipients":[
          {
             "emailAddress":"recipient1@example.com"
          },
          {
             "emailAddress":"recipient2@example.com"
          }
       ],
       "timestamp":"2012-05-25T14:59:38.237-07:00",
       "feedbackId":"00000137860315fd-869464a4-8680-4114-98d3-716fe35851f9-000000"
    },
    "mail":{
       "timestamp":"2012-05-25T14:59:38.237-07:00",
       "messageId":"00000137860315fd-34208509-5b74-41f3-95c5-22c1edc3c924-000000",
       "source":"email_1337983178237@amazon.com",
       "destination":[
          "recipient1@example.com",
          "recipient2@example.com",
          "recipient3@example.com",
          "recipient4@example.com"
       ]
    }
  }

#WITH DSN
 {
     "notificationType":"Bounce",
     "bounce":{
        "bounceType":"Permanent",
        "reportingMTA":"dns; email.example.com",
        "bouncedRecipients":[
           {
              "emailAddress":"username@example.com",
              "status":"5.1.1",
              "action":"failed",
              "diagnosticCode":"smtp; 550 5.1.1 <username@example.com>... User"
           }
        ],
        "bounceSubType":"General",
        "timestamp":"2012-06-19T01:07:52.000Z",
        "feedbackId":"00000138111222aa-33322211-cccc-cccc-cccc-ddddaaaa068a-000000"
     },
     "mail":{
        "timestamp":"2012-06-19T01:05:45.000Z",
        "source":"sender@example.com",
        "messageId":"00000138111222aa-33322211-cccc-cccc-cccc-ddddaaaa0680-000000",
        "destination":[
           "username@example.com"
        ]
     }
  }

#COMPLAINT

 {
  "notificationType":"Complaint",
  "complaint":{
     "complainedRecipients":[
        {
           "emailAddress":"recipient1@example.com"
        }
     ],
     "timestamp":"2012-05-25T14:59:38.613-07:00",
     "feedbackId":"0000013786031775-fea503bc-7497-49e1-881b-a0379bb037d3-000000"
  },
  "mail":{
     "timestamp":"2012-05-25T14:59:38.613-07:00",
     "messageId":"0000013786031775-163e3910-53eb-4c8e-a04a-f29debf88a84-000000",
     "source":"email_1337983178613@amazon.com",
     "destination":[
        "recipient1@example.com",
        "recipient2@example.com",
        "recipient3@example.com",
        "recipient4@example.com"
     ]
  }
  }

#DELIVERY

  {
    "notificationType":"Delivery",
    "mail":{
       "timestamp":"2014-05-28T22:40:59.638Z",
       "messageId":"0000014644fe5ef6-9a483358-9170-4cb4-a269-f5dcdf415321-000000",
       "source":"test@ses-example.com",
       "destination":[
          "success@simulator.amazonses.com",
          "recipient@ses-example.com"
       ]
    },
    "delivery":{
       "timestamp":"2014-05-28T22:41:01.184Z",
       "recipients":["success@simulator.amazonses.com"],
       "processingTimeMillis":546,
       "reportingMTA":"a8-70.smtp-out.amazonses.com",
       "smtpResponse":"250 ok:  Message 64111812 accepted"
    }
  }
=end


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
          }
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
        }
      }
    }

    it "will set a bounce" do
      campaign
      response = send_data(bounce_sns)
      expect(response.status).to be == 200
      expect(campaign.metrics.bounces.size).to be == 1
    end

    it "will set a spam metrc and unsubscribe user" do
      campaign
      response = send_data(complaint_sns)
      expect(response.status).to be == 200
      expect(campaign.metrics.spams.size).to be == 1
      expect(subscriber.subscriptions.first.reload).to be_unsubscribed
    end

  end
end
