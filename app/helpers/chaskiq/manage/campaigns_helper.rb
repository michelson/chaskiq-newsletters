module Chaskiq
  module Manage::CampaignsHelper


    def metric_action_class(metric)
      case metric.action
      when "deliver"
        "plain"
      when "open"
        "info"
      when "click"
        "primary"
      when "bounce"
        "warning"
      when "spam"
        "danger"
      end
    end

    def metric_icon_action_class(metric)
      case metric.action
      when "deliver"
        "check"
      when "open"
        "check"
      when "click"
        "check"
      when "bounce"
        "exclamation"
      when "spam"
        "exclamation-triangle"
      end
    end



  end
end
