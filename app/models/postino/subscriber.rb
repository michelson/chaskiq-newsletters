module Postino
  class Subscriber < ActiveRecord::Base
    belongs_to :list
  end
end
