module Postino
  class Template < ActiveRecord::Base
    has_many :campaigns
  end
end
