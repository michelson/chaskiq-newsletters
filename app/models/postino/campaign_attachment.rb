module Postino
  class CampaignAttachment < ActiveRecord::Base
    belongs_to :campaign
  end
end
