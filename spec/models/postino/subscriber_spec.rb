require 'rails_helper'

module Postino
  RSpec.describe Subscriber, type: :model do
    it{ should belong_to :list }
  end
end
