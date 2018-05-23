module Chaskiq
  module Manage::CampaignsHelper


    def metric_action_class(metric)
      case metric.action
      when "deliver"
        "teal"
      when "open"
        "green"
      when "click"
        "purple"
      when "bounce"
        "yellow"
      when "spam"
        "red"
      end
    end

    def metric_icon_action_class(metric)
      case metric.action
      when "deliver"
        "paper-plane"
      when "open"
        "envelope-open"
      when "click"
        "hand-point-up"
      when "bounce"
        "bell"
      when "spam"
        "error"
      end
    end



  end
end
