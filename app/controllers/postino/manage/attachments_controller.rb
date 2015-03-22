require_dependency "postino/application_controller"

module Postino
  class Manage::AttachmentsController < ApplicationController

    before_filter :find_campaign

    def index
      @attachments = @campaign.attachments.page(params[:page]).per(50)
      respond_to do |format|
        format.html
        format.json { render json: @attachments }
      end
    end

    def show
      @attachment = @campaign.attachments.find(params[:id])
    end

    def new
      @attachment = @campaign.attachments.new
    end

    def create
      @attachment = @campaign.attachments.create(resource_params)
      respond_to do |format|
        format.html
        format.json { render json: @attachment }
      end
    end

  protected

    def find_campaign
      @campaign = Postino::Campaign.find(params[:campaign_id])
    end

    def resource_params
      return [] if request.get?
      params[:attachment] = {} unless params[:attachment].present?
      params[:attachment][:image] = params[:image] if params[:image].present?
      params.require(:attachment).permit! #(:name)
    end

  end
end
