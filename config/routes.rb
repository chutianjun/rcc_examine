require 'sidekiq/web'
Rails.application.routes.draw do
  #挂载web相关的接口
  mount Web::WebControlAPI => '/web'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   mount Sidekiq::Web => '/sidekiq'
end
