require 'rails_helper'

module Chaskiq
  RSpec.describe Attachment, type: :model do
    it{ should belong_to :campaign }

  end
end
