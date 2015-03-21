require_dependency "postino/application_controller"

module Postino
  class CampaignsController < ApplicationController

    layout "postino/empty"

    before_filter :find_campaign

    def show
    end

    def find_campaign
      @campaign  = Postino::Campaign.find(params[:id])
    end

  end
end
