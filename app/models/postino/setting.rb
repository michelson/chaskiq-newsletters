module Chaskiq
  class Setting < ActiveRecord::Base
    belongs_to :campaign
  end
end
