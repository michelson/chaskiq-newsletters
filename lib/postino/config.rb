module Postino
  class Config

    mattr_accessor :mail_settings, :authentication_method

    def self.setup
      yield self
    end

  end
end