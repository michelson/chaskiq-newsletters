class ApplicationMailer < ActionMailer::Base
  #default  from: "Artenlinea.com <messages@artenlinea.com>", #"Artenlinea.com <#{self.smtp_settings[:user_name]}>"
  #         sent_on:       Time.now,
  #         content_type:  "text/html"

  layout 'mailer'

  #default_url_options[:host] = "artenlinea.com"

  def newsletter(campaign, subscriber)

    content_type  = "text/html"

    mail( from: "#{campaign.from_name}<#{campaign.from_email}>",
          to: subscriber.email,
          subject: campaign.subject,
          body: campaign.html_content,
          content_type: content_type )
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
