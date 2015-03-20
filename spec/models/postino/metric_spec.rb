require 'rails_helper'

module Postino
  RSpec.describe Metric, type: :model do
    it{should belong_to :trackable}
  end
end
