module Postino
  class Setting < ActiveRecord::Base
    belongs_to :campaign
  end
end
