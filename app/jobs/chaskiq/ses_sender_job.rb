module Chaskiq
  class SesSenderJob < ActiveJob::Base
    # Set the Queue as Default
    queue_as :mailers

    #send to ses
    def perform(campaign, subscriber)
      mailer = campaign.prepare_mail_to(subscriber)
      response = mailer.deliver
      message_id = response.message_id.gsub("@email.amazonses.com", "")
      campaign.metrics.create(
        trackable: subscriber,
        action: "deliver",
        data: message_id)
    end

  end
end