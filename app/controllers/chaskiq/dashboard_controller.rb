require_dependency "chaskiq/application_controller"

module Chaskiq
  class DashboardController < Chaskiq::ApplicationController
    before_filter :authentication_method

    def show
    end
  end
end
