require_dependency "postino/application_controller"

module Postino
  class Manage::TemplatesController < ApplicationController

    def index
      @templates = Postino::Template.all
    end

    def show
      @template =  Postino::Template.find(params[:id])
    end

    def new
      @template =  Postino::Template.new
    end

    def edit
      @template =  Postino::Template.find(params[:id])
    end

    def update
      @template =  Postino::Template.find(params[:id])
      if @template.update_attributes(resource_params)
        redirect_to manage_templates_path
      else
        render "edit"
      end
    end

    def create
      if @template =  Postino::Template.create(resource_params)
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
