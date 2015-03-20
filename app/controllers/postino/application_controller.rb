module Postino
  class ApplicationController < ActionController::Base

    def get_referrer
      ip = request.ip
      ip = env['HTTP_X_FORWARDED_FOR'].split(",").first if Rails.env.production?
    end

  end
end
