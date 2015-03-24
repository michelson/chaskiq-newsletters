module Chaskiq
  class Attachment < ActiveRecord::Base
    belongs_to :campaign

    mount_uploader :image, ImageUploader

  end
end
