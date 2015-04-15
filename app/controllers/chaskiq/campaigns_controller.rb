require_dependency "chaskiq/application_controller"

module Chaskiq
  class CampaignsController < ApplicationController

    layout "chaskiq/empty"

    before_filter :find_campaign

    def show
    end

    def find_campaign
      @campaign = Chaskiq::Campaign.find(params[:id])
    end

  end
end
