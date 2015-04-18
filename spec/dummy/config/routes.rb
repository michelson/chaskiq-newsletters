Rails.application.routes.draw do

  mount Chaskiq::Engine => '/'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
