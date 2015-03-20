require_dependency "postino/application_controller"

module Postino
  class CampaignsController < ApplicationController

    def show
      @campaign  = Postino::Campaign.find(params[:id])
    end

  end
end
