require_dependency "chaskiq/application_controller"

module Chaskiq
  class Manage::AttachmentsController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :authentication_method
    before_action :find_campaign

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
      create_attachment
      #@attachment = @campaign.attachments.create(resource_params)
      #respond_to do |format|
      #  format.html
      # format.json { render json: @attachment }
      #end
    end

  protected

    def find_campaign
      @campaign = Chaskiq::Campaign.find(params[:campaign_id])
    end

    def resource_params
      return [] if request.get?
      params[:attachment] = {} unless params[:attachment].present?
      params[:attachment][:image] = params[:image] if params[:image].present?
      params.require(:attachment).permit! #(:name)
    end

    def create_attachment
      if params[:file].present? or params[:url].present?

        @attachment = @campaign.attachments.new
        #@attachment.user_id = @post.user.id
        if params[:file]
          filename = params[:file].original_filename
          content_type = params[:file].content_type
          if File.extname(filename).empty?
            params[:file].original_filename = "blob.#{ content_type.split("/").last}"
          end
          @attachment.image = params[:file]
        elsif params[:url]
          handle = open(params[:url])
    
          #if handle.is_a?(StringIO)

            file = Tempfile.new("foo-#{Time.now.to_i}", :encoding => 'ascii-8bit')
            file.write(handle.read)
            file.close

            new_file = CarrierWave::SanitizedFile.new(
              filename: "foo-#{Time.now.to_i}.jpg", 
              type: handle.content_type, 
              tempfile: file
            )
          #end

          @attachment.image = new_file
        end
     
        if @attachment.save
          render json: { url: @attachment.image.url, resource: @attachment }
        else
          render json: {error: @post.errors}, status: 402
        end
      end
    end

  end
end
