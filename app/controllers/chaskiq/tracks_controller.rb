require_dependency "chaskiq/application_controller"

module Chaskiq
  class TracksController < ApplicationController

    before_filter :find_campaign

    #http://localhost:3000/chaskiq/campaigns/1/tracks/1/[click|open|bounce|spam].gif
    %w[open bounce spam].each do |action|
      define_method(action) do
        find_subscriber
        @subscriber.send("track_#{action}".to_sym, { host: get_referrer, campaign_id: @campaign.id })
        #return image
        img_path = Chaskiq::Engine.root.join("app/assets/images/chaskiq", "track.gif")
        send_data File.read(img_path, :mode => "rb"), :filename => '1x1.gif', :type => 'image/gif'
        #send_data File.read(view_context.image_url("chaskiq/track.gif"), :mode => "rb"), :filename => '1x1.gif', :type => 'image/gif'
      end
    end

    def click
      find_subscriber
      #TODO: if subscriber has not an open , we will track open too!
      #that's probably due to plain email or image not beign displayed
      @subscriber.track_click({ host: get_referrer, campaign_id: @campaign.id, data: params[:r] })
      redirect_to params[:r]
    end

  private

    def find_campaign
      @campaign = Chaskiq::Campaign.find(params[:campaign_id])
    end

    def find_subscriber
      @subscriber = @campaign.subscribers.find_by(email: URLcrypt.decode(params[:id]))
    end

  end
end
