Postino::Engine.routes.draw do

  root 'dashboard#show'

  resources :campaigns do
    resources :subscriptions
    resources :wizard, controller: 'campaign_wizard'
  end

  scope 'manage' do
    resources :campaigns do
      member do
        get :preview
        get :test
        get :deliver
      end
      resources :attachments
    end

    resources :lists do
      resources :subscribers
    end
    resources :templates
  end

end
