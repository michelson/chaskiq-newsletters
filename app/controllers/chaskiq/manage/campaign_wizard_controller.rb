require_dependency "chaskiq/application_controller"
require "wicked"

module Chaskiq
  class Manage::CampaignWizardController < ApplicationController

    before_action :authentication_method
    before_action :find_campaign , except: [:create]

    include Wicked::Wizard

    steps :list, :setup, :template, :design, :confirm

    def show
      render_wizard
    end

    def design
      render_wizard
      render :show , layout: false
    end

    def update
      @campaign.update_attributes(resource_params)

      respond_to do |format|
        format.html{render_wizard @campaign}
        format.json{render json: {status: :ok}}
      end
    end

    def create
      @campaign = Chaskiq::Campaign.create(resource_params)
      redirect_to manage_wizard_path(steps.first, :campaign_id => @campaign.id)
    end

    protected

    def find_campaign
      @campaign = Chaskiq::Campaign.find(params[:campaign_id])
    end

    def resource_params
      return [] if request.get?
      params.require(:campaign).permit!
    end

  end
end
