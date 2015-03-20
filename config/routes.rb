Postino::Engine.routes.draw do

  root 'dashboard#show'

  resources :campaigns do
    resources :subscriptions
    resources :tracks do
      member do
        get :click
        get :open
        get :bounce
        get :spam
      end
    end
  end

  scope 'manage' do
    resources :campaigns do
      resources :wizard, controller: 'campaign_wizard'
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
