require_dependency "chaskiq/application_controller"

module Chaskiq
  class Manage::TemplatesController < ApplicationController

    before_action :authentication_method

    def index
      @templates = Chaskiq::Template.all
    end

    def show
      @template =  Chaskiq::Template.find(params[:id])
    end

    def new
      @template =  Chaskiq::Template.new
    end

    def edit
      @template =  Chaskiq::Template.find(params[:id])
    end

    def update
      @template =  Chaskiq::Template.find(params[:id])
      if @template.update_attributes(resource_params)
        redirect_to manage_templates_path
      else
        render "edit"
      end
    end

    def create
      @template =  Chaskiq::Template.create(resource_params)
      if @template.errors.blank?
        redirect_to manage_templates_path
      else
        render "new"
      end
    end

    def resource_params
      return [] if request.get?
      params.require(:template).permit!
    end

  end
end
