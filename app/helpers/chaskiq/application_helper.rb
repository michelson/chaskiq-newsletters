module Chaskiq
  module ApplicationHelper

    def paginate objects, options = {}
      options.reverse_merge!( theme: 'twitter-bootstrap-3' )
      super( objects, options )
    end

    def bootstrap_class_for flash_type
      { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
    end

    def flash_messages(opts = {})

      flash.each do |msg_type, message|
        flash.delete(msg_type)
        concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}") do 
          concat content_tag(:button, "<i class='fa fa-times-circle'></i>".html_safe, class: "close", data: { dismiss: 'alert' })
          concat message 
        end)
      end

      session.delete(:flash)
      nil
    end
    
  end

end
