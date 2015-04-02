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

      message = request_body["Message"]

      case message["notificationType"]
      when "Bounce"
        process_bounce(message)
      when "Complaint"
        process_complaint(message)
      end
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
      subscribers.each do |subscriber|
        subscriber.unsuscribe! if track_type == "spam"
        Chaskiq::Campaign.where(from_email: source).each do |c|
          subscriber.send("track_#{track_type}".to_sym, { host: get_referrer, campaign_id: c.id })
        end
      end
    end

    def send_subscription_confirmation(request_body)
      subscribe_url = request_body['SubscribeURL']
      return nil unless !subscribe_url.to_s.empty? && !subscribe_url.nil?
      subscribe_confirm = open subscribe_url
    end

  end
end
