require 'rails_helper'

module Postino
  RSpec.describe CampaignTemplate, type: :model do
    it{ should belong_to :template }
    it{ should belong_to :campaign }
  end
end
