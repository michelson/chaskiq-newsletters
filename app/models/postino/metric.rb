module Postino
  class Metric < ActiveRecord::Base
    belongs_to :subject, polymorphic: true
    belongs_to :campaign
  end
end
