require_dependency "chaskiq/application_controller"

module Chaskiq
  class Manage::MetricsController < ApplicationController

    before_action :authentication_method
    before_action :find_campaign

    def index
      @q = @campaign.metrics.ransack(params[:q])

      @metrics = @q.result
                  .includes(:trackable)
                  .order("chaskiq_metrics.created_at desc")
                  .page(params[:page])
                  .per(8)

      respond_to do |format|
        format.html{ render "chaskiq/manage/campaigns/show" }
        format.xml { render :xml => @people.to_xml }
      end

    end

  protected

    def find_campaign
      @campaign = Chaskiq::Campaign.find(params[:campaign_id])
    end

  end
end
