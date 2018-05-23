require_dependency "chaskiq/application_controller"

module Chaskiq
  class DashboardController < Chaskiq::ApplicationController
    before_action :authentication_method

    def show
      @campaigns_count = Chaskiq::Campaign.count
      @sends_count     = Chaskiq::Metric.deliveries.size
      @daily_metrics   = Chaskiq::Metric.group_by_day(:created_at, range: 2.weeks.ago.midnight..Time.now).count
      @pie_metrics     = Chaskiq::Metric.group(:action)
      @campaigns       = Chaskiq::Campaign.order("updated_at desc").page(1).per(10)
    
      range = 2.weeks.ago.midnight..Time.now

      @chart_data = [
        {name: :opens,   color: "blue", data: Chaskiq::Metric.opens.group_by_day(:created_at, range: range).count},
        {name: :clicks,  color: "green", data: Chaskiq::Metric.clicks.group_by_day(:created_at, range: range).count},
        {name: :bounces, color: "yellow", data: Chaskiq::Metric.bounces.group_by_day(:created_at, range: range).count},
        {name: :spams,   color: "red", data: Chaskiq::Metric.spams.group_by_day(:created_at, range: range).count}
      ]

    end
  end
end
