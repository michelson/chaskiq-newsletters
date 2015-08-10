Chaskiq::Engine.routes.draw do

  root 'dashboard#show'

  #public
  resources :campaigns, only: :show do
    member do
      get :subscribe
      get :unsubscribe
      get :forward
    end

    resources :subscribers do
      member do
        get :delete
      end
    end

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
  scope 'manage',as: :manage do
    resources :campaigns, controller: 'manage/campaigns' do
      resources :wizard, controller: 'manage/campaign_wizard'
      member do
        get :preview
        get :premailer_preview
        get :test
        get :deliver
        get :clone
        get :editor
        get :purge
        get :iframe
      end
      resources :attachments, controller: 'manage/attachments'
      resources :metrics, controller: 'manage/metrics'
    end

    resources :lists, controller: 'manage/lists' do
      member do
        patch :upload
        get :clear
      end
      resources :subscribers, controller: 'manage/subscribers'
    end
    resources :templates, controller: 'manage/templates'
  end

  resources :hooks do
    collection do
    end
  end

end
