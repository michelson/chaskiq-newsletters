require "wicked"

module Chaskiq
  class ApplicationController < ActionController::Base

    protect_from_forgery with: :exception
    
    def get_referrer
      ip = request.remote_ip
    end

    def authentication_method
      if meth = Chaskiq::Config.authentication_method
        self.send meth
      end
    end

  end
end
