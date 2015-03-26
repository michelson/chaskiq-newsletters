module Chaskiq
  class Metric < ActiveRecord::Base
    belongs_to :trackable, polymorphic: true, required: true

    #system output
    scope :deliveries, ->{where(action: "deliver")}

    #user feedback
    scope :bounces, ->{ where(action: "bounce")}
    scope :opens,   ->{ where(action: "open") }
    scope :clicks,  ->{ where(action: "click")}
    scope :spams,   ->{ where(action: "spam") }

    #reportery
    scope :uniques, ->{group("host")}


    def style_class
      case self.action
      when "deliver"
        "plain"
      when "open"
        "info"
      when "click"
        "primary"
      when "spam"
        "danger"
      end
    end

  end
end
