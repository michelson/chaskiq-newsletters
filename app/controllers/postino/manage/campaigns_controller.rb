require_dependency "postino/application_controller"

module Postino
  class Manage::CampaignsController < ApplicationController

    def index
      @campaigns = Postino::Campaign.all
    end

    def show
      @campaign  = Postino::Campaign.find(params[:id])
    end

    def new
      @campaign = Postino::Campaign.new
    end

    def create

      @campaign = Postino::Campaign.new
      @campaign.step = 1

      @campaign.assign_attributes(resource_params)

      if @campaign.save && @campaign.errors.blank?
        redirect_to manage_campaign_wizard_path(@campaign, "setup")
      else
        render "new"
      end

    end

    def preview
      @campaign  = Postino::Campaign.find(params[:id])
    end

    def test
      @campaign  = Postino::Campaign.find(params[:id])
      @campaign.test_newsletter
      flash[:notice] = "test sended"
      redirect_to manage_campaigns_path()
    end

    def deliver
      @campaign  = Postino::Campaign.find(params[:id])
      @campaign.send_newsletter
      flash[:notice] = "newsletter sended"
      redirect_to manage_campaigns_path()
    end

  protected

    def resource_params
      return [] if request.get?
      params.require(:campaign).permit(:list_id)
    end


  end
end
