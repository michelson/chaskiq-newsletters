require 'net/http'

module Postino
  class Campaign < ActiveRecord::Base

    belongs_to :parent, class_name: "Postino::Campaign"
    belongs_to :list
    has_many :subscribers, through: :list
    has_many :attachments
    has_many :metrics
    #has_one :campaign_template
    #has_one :template, through: :campaign_template
    belongs_to :template, class_name: "Postino::Template"
    #accepts_nested_attributes_for :template, :campaign_template

    attr_accessor :step

    validates :subject, presence: true , unless: :step_1?
    validates :from_name, presence: true, unless: :step_1?
    validates :from_email, presence: true, unless: :step_1?

    #validates :plain_content, presence: true, unless: :template_step?
    validates :html_content, presence: true, if: :template_step?

    before_save :detect_changed_template

    mount_uploader :logo, CampaignLogoUploader

    def delivery_progress
      return 0 if metrics.deliveries.size.zero?
      subscribers.size.to_f / metrics.deliveries.size.to_f * 100.0
    end

    def step_1?
      self.step == 1
    end

    def template_step?
      self.step == "template"
    end

    def send_newsletter
      #with custom
      #Postino::CampaignMailer.my_email.delivery_method.settings.merge!(SMTP_SETTINGS)
      #send newsletter here
      self.apply_premailer
      self.subscribers.each do |s|
        push_notification(s)
      end
    end

    def test_newsletter
      Postino::CampaignMailer.test(self).deliver_later
    end

    def detect_changed_template
      if self.changes.include?("template_id")
        copy_template
      end
    end

    #deliver email + create metric
    def push_notification(subscriber)
      self.metrics.create(trackable: subscriber, action: "deliver")
      mailer = Postino::CampaignMailer.newsletter(self, subscriber) #deliver_later
      if Rails.env.production?
        mailer.deliver_later
      else
        mailer.deliver_now
      end
    end

    def copy_template
      self.html_content = self.template.body
    end

    def campaign_url
      host = Rails.application.routes.default_url_options[:host]
      campaign_url = "#{host}/campaigns/#{self.id}"
    end

    def apply_premailer
      host = Rails.application.routes.default_url_options[:host]
      url = URI.parse("#{host}/manage/campaigns/#{self.id}/premailer_preview")

      premailer = Premailer.new(url, :adapter => :nokogiri, :escape_url_attributes => false)
      self.update_column(:premailer, premailer.to_inline_css)
    end

    def attributes_for_mailer(subscriber)

      subscriber_url = "#{campaign_url}/subscribers/#{subscriber.encoded_id}"

=begin
        { campaign_url: "<a href='#{campaign_url}' class='utilityLink'>#{self.name}</a>".html_safe,
        campaign_unsubscribe: "<a href='#{subscriber_url}/delete' class='utilityLink'>Unsubscribe</a>".html_safe,
        campaign_subscribe: "<a href='#{campaign_url}/subscribers/new' class='utilityLink'>Subscribe</a>".html_safe,
        campaign_description: "#{self.description}" ,
      }
=end
      { campaign_url: "#{campaign_url}",
        campaign_unsubscribe: "#{subscriber_url}/delete",
        campaign_subscribe: "#{campaign_url}/subscribers/new",
        campaign_description: "#{self.description}" ,
      }
    end

    def mustache_template_for(subscriber)

      link_prefix = host + "/campaigns/#{self.id}/tracks/#{subscriber.encoded_id}?r="
      html = Postino::LinkRenamer.convert(premailer, link_prefix)

      Mustache.render(html, subscriber.attributes.merge(attributes_for_mailer(subscriber)) )
    end

    def compiled_template_for(subscriber)
      mustache_template_for(subscriber)
    end

    def host
      Rails.application.routes.default_url_options[:host] || "http://localhost:3000"
    end

  end
end
