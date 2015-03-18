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
      if @campaign = Postino::Campaign.create(campaign_params)
        redirect_to campaigns_wizard_path(@campaign)
      else
        render "new"
      end
    end

  end
end
