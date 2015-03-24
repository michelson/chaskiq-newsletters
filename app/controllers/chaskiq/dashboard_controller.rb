require_dependency "chaskiq/application_controller"

module Chaskiq
  class DashboardController < Chaskiq::ApplicationController
    before_filter :authentication_method

    def show
      @campaigns_count = Chaskiq::Campaign.count
      @sends_count = Chaskiq::Metric.deliveries.size

    end
  end
end
