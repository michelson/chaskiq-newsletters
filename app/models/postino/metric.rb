module Postino
  class Metric < ActiveRecord::Base
    belongs_to :subject
    belongs_to :campaign
  end
end
