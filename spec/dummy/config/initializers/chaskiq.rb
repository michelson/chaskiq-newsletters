require "chaskiq"

Chaskiq::Config.setup do |config|
  #config.authentication_method = :authenticate_user!
  config.ses_access_key = ENV['FOG_ACCESS_KEY_ID']
  config.ses_access_secret_key = ENV['FOG_SECRET_ACCESS_KEY']
  config.s3_bucket = ENV['FOG_BUCKET']
  config.chaskiq_secret_key = "chaskiq123"

  config.is_admin_method = ->(user){
    true
  }
end

Chaskiq::ApplicationController.send(:include, ApplicationHelper)