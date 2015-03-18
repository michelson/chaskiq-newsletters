require_dependency "postino/application_controller"

module Postino
  class CampaignsController < ApplicationController

    #respond_to :js , :json , :html

    def index
      @campaigns = Postino::Campaign.all
    end

    def show
      @campaign  = Postino::Campaign.find(params[:id])
    end

  end
end
