module Postino
  class Subscriber < ActiveRecord::Base
    belongs_to :list
    has_many :metrics , as: :subject
  end
end
