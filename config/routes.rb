Postino::Engine.routes.draw do

  resources :campaigns do
    resources :subscriptions
  end

  scope 'manage' do
    resources :campaigns do
      resources :wizard, controller: 'campaign/wizard'
      resources :attachments
    end
    resources :lists
  end

end
