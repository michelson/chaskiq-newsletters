require_dependency "chaskiq/application_controller"

module Chaskiq
  class Manage::CampaignsController < ApplicationController

    before_filter :authentication_method, except: [:preview, :premailer_preview]

    def index
      @campaigns = Chaskiq::Campaign.all
    end

    def show
      @campaign  = Chaskiq::Campaign.find(params[:id])
    end

    def new
      @campaign = Chaskiq::Campaign.new
    end

    def create

      @campaign = Chaskiq::Campaign.new
      @campaign.step = 1

      @campaign.assign_attributes(resource_params)

      if @campaign.save && @campaign.errors.blank?
        redirect_to manage_campaign_wizard_path(@campaign, "setup")
      else
        render "new"
      end

    end

    def preview
      @campaign  = Chaskiq::Campaign.find(params[:id])
      @campaign.apply_premailer
      render layout: false
    end

    def premailer_preview
      @campaign  = Chaskiq::Campaign.find(params[:id])
      render layout: false
    end

    def editor
      @campaign  = Chaskiq::Campaign.find(params[:id])
      render "editor_frame", layout: false
    end

    def test
      @campaign  = Chaskiq::Campaign.find(params[:id])
      @campaign.test_newsletter
      flash[:notice] = "test sended"
      redirect_to manage_campaigns_path()
    end

    def deliver
      @campaign  = Chaskiq::Campaign.find(params[:id])
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
