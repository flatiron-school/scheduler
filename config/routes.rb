Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :objectives

  resources :user_cohorts
  resources :cohorts, param: :slug do 
    resources :schedules, param: :slug
    post "/schedules/:slug/deploy", to: "schedules#deploy", as: "schedule/deploy"
    post "/schedules/:slug/reserve-rooms", to: "schedules#reserve_rooms", as: "schedule/reserve"
    post "/schedules/:slug/remove-lab", to: "schedule_labs#remove_lab", as: "schedule/remove-lab"
    post "/schedules/:slug/remove-activity", to: "schedule_activities#remove_activity", as: "schedule/remove-activity"
    post "/schedules/:slug/remove-objective", to: "schedule_objectives#remove_objective", as: "schedule/remove-objective"
    post '/event-listener' => 'webhooks#event_listener'
  end

  get 'cohorts/:slug/blog-schedule', to: "cohorts#get_blog_schedule"

 
  root "cohorts#index"
end
