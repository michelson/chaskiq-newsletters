module Postino
  class Attachment < ActiveRecord::Base
    belongs_to :campaign
  end
end
