require "aasm"

module Chaskiq
  class Subscriber < ActiveRecord::Base

    has_many :subscriptions
    has_many :lists, through: :subscriptions, class_name: "Chaskiq::List"
    has_many :metrics , as: :trackable
    has_many :campaigns, through: :lists, class_name: "Chaskiq::Campaign"

    validates :email , presence: true
    validates :name , presence: true

    include AASM

    aasm :column => :state do # default column: aasm_state
      state :passive, :initial => true
      state :subscribed, :after_enter => :notify_subscription
      state :unsubscribed, :after_enter => :notify_unsubscription
      #state :bounced, :after_enter => :make_bounced
      #state :complained, :after_enter => :make_complained

      event :suscribe do
        transitions :from => [:passive, :unsubscribed], :to => :subscribed
      end

      event :unsuscribe do
        transitions :from => [:subscribed, :passive], :to => :unsubscribed
      end
    end

    def notify_unsubscription
      puts "Pending"
    end

    def notify_subscription
      #we should only unsubscribe when process is made from interface, not from sns notification
      puts "Pending"
    end

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
