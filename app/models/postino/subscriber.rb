require "aasm"

module Postino
  class Subscriber < ActiveRecord::Base

    belongs_to :list
    has_many :metrics , as: :trackable

    include AASM

    aasm do # default column: aasm_state
      state :pasive, :initial => true
      state :subscribed
      state :unsubscribed

      event :suscribe, :after_commit => :notify_subscription do
        transitions :from => [:passive, :unsubscribed], :to => :subscribed
      end

      event :unsuscribe, :after_commit => :notify_unsubscription do
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
