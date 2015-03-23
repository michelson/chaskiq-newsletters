require_dependency "postino/application_controller"

module Postino
  class Manage::CampaignsController < ApplicationController

    before_filter :authentication_method, except: [:preview, :premailer_preview]

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

      @campaign = Postino::Campaign.new
      @campaign.step = 1

      @campaign.assign_attributes(resource_params)

      if @campaign.save && @campaign.errors.blank?
        redirect_to manage_campaign_wizard_path(@campaign, "setup")
      else
        render "new"
      end

    end

    def preview


      @campaign  = Postino::Campaign.find(params[:id])
      @campaign.apply_premailer

=begin
      out = Sanitize.fragment(@campaign.html_content, :elements => ['img', 'table', 'tbody', 'td', 'th', 'p', 'span', 'ul', 'li'],
        :attributes => {
          :all=>['class', 'id', 'style', 'valign', 'align'],
          'a'=> ['href', 'title'],'span' => ['class'],
          'tbody'=>["class", "id", "style"],
          'table'=>['width','height', 'cellspacing', 'cellpadding', 'border', 'cellspacing', 'cellpadding', 'border', 'align', 'id', 'class', 'style' ],
          'td'=>['id', 'class', 'style', 'valign', 'align'],
          'css' => {:properties => ['color', 'border', 'background',       'padding-top', 'padding-right', 'padding-bottom', 'padding-left']},
          'remove_contents' => ['script', 'style', 'object', 'iframe', 'embed']

          })


      @template = out.html_safe
=end
      render layout: false
    end

    def premailer_preview

      @campaign  = Postino::Campaign.find(params[:id])
      render layout: false
    end

    def editor
      @campaign  = Postino::Campaign.find(params[:id])
      render "editor_frame", layout: false
    end

    def test
      @campaign  = Postino::Campaign.find(params[:id])
      @campaign.test_newsletter
      flash[:notice] = "test sended"
      redirect_to manage_campaigns_path()
    end

    def deliver
      @campaign  = Postino::Campaign.find(params[:id])
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
