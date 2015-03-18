module Postino
  class Campaign < ActiveRecord::Base
    belongs_to :parent
  end
end
