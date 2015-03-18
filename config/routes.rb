Postino::Engine.routes.draw do

  resources :campaigns do
    resources :subscriptions
    resources :wizard, controller: 'campaign_wizard'
  end

  scope 'manage' do
    resources :campaigns do
      resources :attachments
    end

    resources :lists do
      resources :subscribers
    end
    resources :templates
  end

end
