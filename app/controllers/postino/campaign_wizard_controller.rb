require_dependency "postino/application_controller"

module Postino
  class CampaignWizardController < ApplicationController

    include Wicked::Wizard

    steps :list, :setup, :template, :design, :confirm

    def show
      @campaign = Postino::Campaign.find(params[:campaign_id])
      render_wizard
    end


    def update
      @campaign = Postino::Campaign.find(params[:campaign_id])
      @campaign.update_attributes(params[:campaign])
      render_wizard @campaign
    end


    def create
      @campaign = Postino::Campaign.create
      redirect_to wizard_path(steps.first, :campaign_id => @campaign.id)
    end

  end
end
