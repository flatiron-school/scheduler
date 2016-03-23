Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :objectives

  resources :user_cohorts
  resources :cohorts, param: :slug do 
    resources :schedules, param: :slug
    post "/schedules/:slug/deploy", to: "schedules#deploy", as: "schedule/deploy"
    post "/schedules/:slug/reserve-rooms", to: "schedules#reserve_rooms", as: "schedule/reserve"
  end

  get 'cohorts/:slug/blog-schedule', to: "cohorts#get_blog_schedule"

 
  root "cohorts#index"
end
