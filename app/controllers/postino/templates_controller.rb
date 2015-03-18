require_dependency "postino/application_controller"

module Postino
  class TemplatesController < ApplicationController

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
        redirect_to templates_path
      else
        render "new"
      end
    end

    def create
      if @template =  Postino::Template.create(resource_params)
        redirect_to templates_path
      else
        render "new"
      end
    end


  end
end
