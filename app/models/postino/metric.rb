module Postino
  class Metric < ActiveRecord::Base
    belongs_to :trackable, polymorphic: true, required: true

    scope :deliveries, ->{where(action: "deliver")}
  end
end
