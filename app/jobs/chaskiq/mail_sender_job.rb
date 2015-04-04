module Chaskiq
  class MailSenderJob < ActiveJob::Base
    # Set the Queue as Default
    queue_as :default

    #send to all list with state passive & subscribed
    def perform(campaign)
      campaign.apply_premailer
      campaign.list.subscriptions.availables.each do |s|
        campaign.push_notification(s.subscriber)
      end
    end

  end
end