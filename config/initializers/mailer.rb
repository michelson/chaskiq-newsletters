ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => ENV['FOG_ACCESS_KEY_ID'],
  :secret_access_key => ENV['FOG_SECRET_ACCESS_KEY']