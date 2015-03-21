require_dependency "postino/application_controller"

module Postino
  class SubscribersController < ApplicationController

    before_filter :find_base_models

    layout "postino/empty"

    def show
      #TODO, we should obfustate code
      @subscriber = @campaign.list.subscribers.find(params[:id])
      render "edit"
    end

    def new
      @subscriber = @campaign.list.subscribers.new
    end

    def edit
      @subscriber = @campaign.list.subscribers.find(params[:id])
    end

    def update
      @subscriber = @campaign.list.subscribers.find(params[:id])
      if @subscriber.update_attributes(resource_params) && @subscriber.errors.blank?
        flash[:notice] = "you did it!"
        @subscriber.suscribe! unless @subscriber.subscribed?
        redirect_to campaign_path(@campaign)
      else
        render "edit"
      end
    end

    def create
      @subscriber = @campaign.list.subscribers.create(resource_params)
      if @subscriber.errors.blank?
        flash[:notice] = "you did it!"
        redirect_to campaign_path(@campaign)
      else
        render "new"
      end
    end

    def delete
      @subscriber = @campaign.list.subscribers.find(params[:id])
    end

    def destroy
      @subscriber = @campaign.list.subscribers.find(params[:id])
      begin
        if @subscriber.unsuscribe!
          flash[:notice] = "Thanks, you will not receive more emails from this newsletter!"
          redirect_to campaign_path(@campaign)
        end
      rescue
        flash[:notice] = "Thanks, you will not receive more emails from this newsletter!"
        redirect_to campaign_path(@campaign)
      end
    end


  protected

    def find_base_models
      @campaign = Postino::Campaign.find(params[:campaign_id])
      @list = @campaign.list
    end


    def resource_params
      return [] if request.get?
      params.require(:subscriber).permit(:email, :name, :last_name)
    end

  end
end
