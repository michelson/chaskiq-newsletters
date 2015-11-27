
module Chaskiq
  class Subscriber < ActiveRecord::Base

    has_many :subscriptions
    has_many :lists, through: :subscriptions, class_name: "Chaskiq::List"
    has_many :metrics , as: :trackable
    has_many :campaigns, through: :lists, class_name: "Chaskiq::Campaign"

    validates :email , presence: true
    
    #validates :name , presence: true

    %w[click open bounce spam].each do |action|
      define_method("track_#{action}") do |opts|
        m = self.metrics.new
        m.assign_attributes(opts)
        m.action = action
        m.save
      end
    end

    def encoded_id
      URLcrypt.encode(self.email)
    end

    def decoded_id
      URLcrypt.decode(self.email)
    end

    def style_class
      case self.state
      when "passive"
        "plain"
      when "subscribed"
        "information"
      when "unsusbscribed"
        "warning"
      end
    end

  end
end
