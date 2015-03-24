require 'rails_helper'

module Chaskiq
  RSpec.describe Metric, type: :model do
    it{should belong_to :trackable}
  end
end
