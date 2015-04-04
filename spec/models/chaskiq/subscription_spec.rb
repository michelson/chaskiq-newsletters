require 'rails_helper'

module Chaskiq
  RSpec.describe Subscription, type: :model do
    it{ should belong_to :campaign }
    it{ should belong_to :list }
    it{ should belong_to :subscriber }
  end
end
