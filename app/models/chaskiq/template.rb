module Chaskiq
  class Template < ActiveRecord::Base
    has_many :campaigns
    validates :body, presence: true
    validates :name, presence: true
  end
end
