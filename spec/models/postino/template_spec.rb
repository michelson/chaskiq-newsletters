require 'rails_helper'

module Postino
  RSpec.describe Template, type: :model do
    it{ should have_many :campaign_templates }
    it{ should have_many( :campaigns).through(:campaign_templates) }
  end
end
