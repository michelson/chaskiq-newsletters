module Postino
  class Metric < ActiveRecord::Base
    belongs_to :trackable, polymorphic: true, required: true

    scope :deliveries, ->{where(action: "deliver")}
    scope :bounces, ->{where(action: "bounce")}
    scope :opens, ->{where(action: "open")}
    scope :clicks, ->{where(action: "click")}
    scope :spams, ->{where(action: "spams")}
    scope :uniques, ->{group("host")}
  end
end
