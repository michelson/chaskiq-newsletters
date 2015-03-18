module Postino
  class Template < ActiveRecord::Base
    has_many :campaign_templates
    has_many :campaigns, through: :campaign_templates
  end
end
