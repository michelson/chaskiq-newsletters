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

    def chart_series(collection , start_time, end_time, index)
      (start_time.to_date..end_time.to_date).map do |date|
       d = collection.rows.detect{ |d| d[0] == date.strftime('%Y%m%d') }
       d.blank? ? 0 : d[index].to_i
      end
    end

  end
end
