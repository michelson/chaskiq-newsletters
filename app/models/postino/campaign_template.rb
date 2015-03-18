module Postino
  class CampaignTemplate < ActiveRecord::Base
    belongs_to :template
    belongs_to :campaign
  end
end
