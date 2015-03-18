require_dependency "postino/application_controller"

module Postino
  class CampaignsController < ApplicationController

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
        binding.pry
        redirect_to campaign_wizard_path(@campaign)
      else
        render "new"
      end

    end

    protected

    def resource_params
      return [] if request.get?
      params.require(:campaign).permit(:list_id)
    end

  end
end
