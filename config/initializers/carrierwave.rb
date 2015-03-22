CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['FOG_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['FOG_SECRET_ACCESS_KEY'] ,
    #:region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
    #:hosts                  => 's3.example.com',             # optional, defaults to nil
    #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = ENV['FOG_BUCKET']           # required
  #config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end