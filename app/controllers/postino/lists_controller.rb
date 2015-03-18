require_dependency "postino/application_controller"

module Postino
  class ListsController < ApplicationController

    def index
      @lists = Postino::List.all
    end

    def show
      @list =  Postino::List.find(params[:id])
    end

    def new
      @list =  Postino::List.new
    end

    def edit
      @list =  Postino::List.find(params[:id])
    end

    def update
      @list =  Postino::List.find(params[:id])
      if @list.update_attributes(resource_params)
        redirect_to lists_path
      else
        render "new"
      end
    end

    def create
      if @list =  Postino::List.create(resource_params)
        redirect_to lists_path
      else
        render "new"
      end
    end

  protected

    def resource_params
      return [] if request.get?
      [ params.require(:list).permit(:name) ]
    end

  end
end
