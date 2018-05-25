# encoding: utf-8
module Chaskiq
  class PreviewUploader < CarrierWave::Uploader::Base

    include CarrierWave::MiniMagick
    storage :fog
    
    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      #TODO: fix this to:
      #[model.user_id, model.class.table_name.to_s, model.id].compact.join("/")
      if Rails.env.production?
        # http://s3.amazonaws.com/artenlinea/621/art_works/12341/big_thumb/66196detallefrutus.jpg
        "#{model.class.table_name.to_s}/#{model.id}"
      elsif Rails.env.test? or Rails.env.development?
        [model.class.table_name.to_s, model.id].compact.join("/")      
        # needed to port all images to new path
      end
    end

    def default_url
      ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.jpg"].compact.join('_'))
    end

    def full_filename(for_file = model.image.file)
      [version_name, for_file].compact.join('/')
    end

    version :original do
    end

    version :resize do
      #{:type=>'resize_to_width',:size=>550,:name=>'resize'},
      process resize_to_fit: [550, 1024]
      process :quality => 100
    end

    version :thumb do
      #{:type=>'cropped_thumbnail',:size=>100,:name=>'thumb'}
      process resize_to_fill: [400, 400, 'North']
      process :quality => 100
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

  end
end
