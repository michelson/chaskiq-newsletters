require "aasm"

module Postino
  class Subscriber < ActiveRecord::Base

    belongs_to :list
    has_many :metrics , as: :trackable

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

  end
end
