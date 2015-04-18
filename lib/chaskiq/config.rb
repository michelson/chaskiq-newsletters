module Chaskiq
  class Config

    mattr_accessor :mail_settings,
    :authentication_method,
    :ses_access_key,
    :ses_access_secret_key,
    :s3_bucket

    def self.setup
      yield self
    end

    def self.config_ses
       ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
      :access_key_id     => ses_access_key,
      :secret_access_key => ses_access_secret_key
    end

    def self.config_fog
      CarrierWave.configure do |config|
        config.fog_credentials = {
          :provider               => 'AWS',
          :aws_access_key_id      => ses_access_key,
          :aws_secret_access_key  => ses_access_secret_key ,
          #:region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
          #:hosts                  => 's3.example.com',             # optional, defaults to nil
          #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
        }
        config.fog_directory  = s3_bucket           # required
        #config.fog_public    = false                                   # optional, defaults to true
        config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
      end
    end

  end
end