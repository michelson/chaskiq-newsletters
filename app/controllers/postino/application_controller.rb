require "wicked"

module Chaskiq
  class ApplicationController < ActionController::Base

    def get_referrer
      ip = request.ip
      ip = env['HTTP_X_FORWARDED_FOR'].split(",").first if Rails.env.production?
    end

    def authentication_method
      if meth = Chaskiq::Config.authentication_method
        self.send meth
      end
    end

  end
end
