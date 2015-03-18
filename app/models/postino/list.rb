module Postino
  class List < ActiveRecord::Base
    has_many :subscribers
  end
end
