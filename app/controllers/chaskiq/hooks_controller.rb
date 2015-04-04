require_dependency "chaskiq/application_controller"

require "open-uri"
module Chaskiq
  class HooksController < ApplicationController

    layout false

    def create
      # get amazon message type and topic
      amz_message_type = request.headers['x-amz-sns-message-type']
      amz_sns_topic = request.headers['x-amz-sns-topic-arn']

      #return unless !amz_sns_topic.nil? &&
      #amz_sns_topic.to_s.downcase == 'arn:aws:sns:us-west-2:867544872691:User_Data_Updates'
      request_body = JSON.parse request.body.read

      # if this is the first time confirmation of subscription, then confirm it
      if amz_message_type.to_s.downcase == 'subscriptionconfirmation'
        send_subscription_confirmation request_body
        render text: "ok" and return
      end

      process_notification(request_body)
      render text: "ok" and return
    end

private

    def process_notification(request_body)

      message = parse_body_message(request_body["Message"])

      case message["notificationType"]
      when "Bounce"
        process_bounce(message)
      when "Complaint"
        process_complaint(message)
      end
    end

    def parse_body_message(body)
      JSON.parse(body)
    end

    def process_bounce(m)
      emails = m["bounce"]["bouncedRecipients"].map{|o| o["emailAddress"] }
      source = m["mail"]["source"]
      track_message_for("bounce", emails, source)
    end

    def process_complaint(m)
      emails = m["complaint"]["complainedRecipients"].map{|o| o["emailAddress"] }
      source = m["mail"]["source"]
      track_message_for("spam", emails, source)
    end

    def track_message_for(track_type, emails, source)
      subscribers = Chaskiq::Subscriber.where(email: emails )
      campaign = Chaskiq::Campaign.find_by(from_email: source)
      subscriptions = campaign.subscriptions.where(subscriber_id: subscribers.map(&:id) )

      subscriptions.each do |s|
        s.unsubscribe! if track_type == "spam"
        s.subscriber.send("track_#{track_type}".to_sym, { host: get_referrer, campaign_id: campaign.id })
      end

    end

    def send_subscription_confirmation(request_body)
      subscribe_url = request_body['SubscribeURL']
      return nil unless !subscribe_url.to_s.empty? && !subscribe_url.nil?
      subscribe_confirm = open subscribe_url
    end

  end
end
