require 'rails_helper'

module Chaskiq
  RSpec.describe Template, type: :model do
    it{ should have_many(:campaigns) }
  end
end
