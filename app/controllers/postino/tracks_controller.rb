require_dependency "postino/application_controller"

module Postino
  class TracksController < ApplicationController

    before_filter :find_campaign

    #http://localhost:3000/postino/campaigns/1/tracks/1/[click|open|bounce|spam].gif
    %w[click open bounce spam].each do |action|
      define_method(action) do
        find_subscriber
        @subscriber.send("track_#{action}".to_sym, { host: get_referrer, campaign_id: @campaign.id })
        #return image
        img_path = Postino::Engine.root.join("app/assets/images/postino", "track.gif")
        send_data File.read(img_path, :mode => "rb"), :filename => '1x1.gif', :type => 'image/gif'
        #send_data File.read(view_context.image_url("postino/track.gif"), :mode => "rb"), :filename => '1x1.gif', :type => 'image/gif'
      end
    end

  private

    def find_campaign
      @campaign = Postino::Campaign.find(params[:campaign_id])
    end

    def find_subscriber
      @subscriber = @campaign.subscribers.find(params[:id])
    end

  end
end
