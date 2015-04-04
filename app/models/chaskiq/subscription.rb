module Chaskiq
  class Subscription < ActiveRecord::Base
    belongs_to :campaign
    belongs_to :subscriber
    belongs_to :list
  end
end
