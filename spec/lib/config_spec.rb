require 'rails_helper'

module Chaskiq
  RSpec.describe Config, type: :model do


    let(:chaskiq_config){  Chaskiq::Config }

    it "will setup" do
      chaskiq_config.setup do |config|
        config.mail_settings = {
                          :address => "someuser@gmail.com",
                          :user_name => "xxx", # Your SMTP user here.
                          :password => "xxx", # Your SMTP password here.
                          :authentication => :login,
                          :enable_starttls_auto => true
                        }
      end
      expect(chaskiq_config.mail_settings).to be_an_instance_of Hash
      expect(Chaskiq::Config.mail_settings).to be_an_instance_of Hash
    end

  end
end
