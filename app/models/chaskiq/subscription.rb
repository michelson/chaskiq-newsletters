require "aasm"

module Chaskiq
  class Subscription < ActiveRecord::Base
    belongs_to :subscriber
    belongs_to :list
    has_many :campaigns, through: :list

    scope :availables, ->{ where(["chaskiq_subscriptions.state =? or chaskiq_subscriptions.state=?", "passive", "subscribed"]) }

    include AASM

    aasm :column => :state do # default column: aasm_state
      state :passive, :initial => true
      state :subscribed, :after_enter => :notify_subscription
      state :unsubscribed, :after_enter => :notify_unsubscription
      #state :bounced, :after_enter => :make_bounced
      #state :complained, :after_enter => :make_complained

      event :subscribe do
        transitions :from => [:passive, :unsubscribed], :to => :subscribed
      end

      event :unsubscribe do
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


  end
end
