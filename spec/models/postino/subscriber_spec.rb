require 'rails_helper'

module Postino
  RSpec.describe Subscriber, type: :model do
    it{ should belong_to :list }
    it{ should have_many :metrics }
  end
end
