require_dependency "chaskiq/application_controller"

module Chaskiq
  class DashboardController < Chaskiq::ApplicationController
    before_action :authentication_method

    def show
      @campaigns_count = Chaskiq::Campaign.count
      @sends_count = Chaskiq::Metric.deliveries.size
      @daily_metrics = Chaskiq::Metric.group_by_day(:created_at, range: 2.weeks.ago.midnight..Time.now).count
      @pie_metrics = Chaskiq::Metric.group(:action)
    end
  end
end
