require 'mustache'

class ApplicationMailer < ActionMailer::Base

  layout 'mailer'

  def newsletter(campaign, subscriber)

    content_type  = "text/html"

    attrs = subscriber.attributes

    @campaign = campaign

    @subscriber = subscriber

    @body = campaign.compiled_template_for(subscriber).html_safe

    mail( from: "#{campaign.from_name}<#{campaign.from_email}>",
          to: subscriber.email,
          subject: campaign.subject,
          content_type: content_type,
          return_path: campaign.reply_email )
  end

  def test(campaign)

    content_type  = "text/html"

    mail( from: "#{campaign.from_name}<#{campaign.from_email}>",
          to: "miguelmichelson@gmail.com",
          subject: campaign.subject,
          body: campaign.html_content,
          content_type: content_type )
  end

end
