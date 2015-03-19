module Postino
  class Config

    mattr_accessor :mail_settings

    def self.setup
      yield self
    end

  end
end