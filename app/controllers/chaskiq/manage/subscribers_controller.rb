require_dependency "chaskiq/application_controller"

module Chaskiq
  class Manage::SubscribersController < ApplicationController
    before_action :authentication_method

    def edit
      @list = Chaskiq::List.find(params[:list_id])
      @subscriber = @list.subscribers.find(params[:id])
      render "edit"
    end

    def update
      @list = Chaskiq::List.find(params[:list_id])
      @subscriber = @list.subscribers.find(params[:id])
      params[:subscriber][:options] = JSON.parse(params[:subscriber][:options]) rescue nil
      if @subscriber.update_attributes(resource_params)
        redirect_to manage_list_path(@list)
      else
        render "edit"
      end
    end

  protected

    def resource_params
      return [] if request.get?
      params.require(:subscriber).permit! #(:name)
    end

  end
end
