Rails.application.routes.draw do
  resources :cohorts, param: :slug
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  root "cohorts#new"
end
