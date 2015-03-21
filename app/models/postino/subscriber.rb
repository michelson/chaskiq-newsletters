require "aasm"

module Postino
  class Subscriber < ActiveRecord::Base

    belongs_to :list
    has_many :metrics , as: :trackable
    has_one :campaign , through: :list , class_name: "Postino::Campaign"

    validates :email , presence: true
    validates :name , presence: true

    include AASM

    aasm :column => :state do # default column: aasm_state
      state :passive, :initial => true
      state :subscribed, :after_enter => :notify_subscription
      state :unsubscribed, :after_enter => :notify_unsubscription

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

  end
end
