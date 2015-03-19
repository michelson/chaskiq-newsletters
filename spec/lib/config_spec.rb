require 'rails_helper'

module Postino
  RSpec.describe Config, type: :model do


    let(:postino_config){  Postino::Config }

    it "will setup" do
      postino_config.setup do |config|
        config.mail_settings = {
                          :address => "someuser@gmail.com",
                          :user_name => "xxx", # Your SMTP user here.
                          :password => "xxx", # Your SMTP password here.
                          :authentication => :login,
                          :enable_starttls_auto => true
                        }
      end
      expect(postino_config.mail_settings).to be_an_instance_of Hash
      expect(Postino::Config.mail_settings).to be_an_instance_of Hash
    end

  end
end
