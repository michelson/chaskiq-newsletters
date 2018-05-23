module Chaskiq
  class Attachment < ActiveRecord::Base
    belongs_to :campaign, optional: true

    mount_uploader :image, ImageUploader

  end
end
