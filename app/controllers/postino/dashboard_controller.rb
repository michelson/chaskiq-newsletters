require_dependency "postino/application_controller"

module Postino
  class DashboardController < Postino::ApplicationController
    before_filter :authentication_method

    def show
    end
  end
end
