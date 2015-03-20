Postino::Engine.routes.draw do

  root 'dashboard#show'

  #public
  resources :campaigns, only: :show do
    resources :tracks do
      member do
        get :click
        get :open
        get :bounce
        get :spam
      end
    end
  end

  #private
  scope 'manage' do
    resources :campaigns, controller: 'manage/campaigns' do
      resources :wizard, controller: 'manage/campaign_wizard'
      member do
        get :preview
        get :test
        get :deliver
      end
      resources :attachments, controller: 'manage/attachments'
    end

    resources :lists, controller: 'manage/lists' do
      resources :subscribers, controller: 'manage/subscribers'
    end
    resources :templates, controller: 'manage/templates'
  end

end
