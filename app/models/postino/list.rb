module Postino
  class List < ActiveRecord::Base
    has_many :subscribers
    has_many :campaigns
  end
end
