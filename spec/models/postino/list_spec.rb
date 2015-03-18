require 'rails_helper'

module Postino
  RSpec.describe List, type: :model do
    it{ should have_many :subscribers }
    it{ should have_many :campaigns }
  end
end
