require_dependency "chaskiq/application_controller"

module Chaskiq
  class Manage::ListsController < ApplicationController

    before_filter :authentication_method

    def index
      @lists = Chaskiq::List.page(params[:page]).per(50)
    end

    def show
      @list =  Chaskiq::List.find(params[:id])
      @subscribers = @list.subscribers.page(params[:page]).per(50)
    end

    def new
      @list =  Chaskiq::List.new
    end

    def edit
      @list =  Chaskiq::List.find(params[:id])
    end

    def update
      @list =  Chaskiq::List.find(params[:id])
      if @list.update_attributes(resource_params)
        redirect_to manage_lists_path
      else
        render "new"
      end
    end

    def create
      if @list =  Chaskiq::List.create(resource_params)
        redirect_to manage_lists_path
      else
        render "new"
      end
    end

  protected

    def resource_params
      return [] if request.get?
      params.require(:list).permit! #(:name)
    end

  end
end
