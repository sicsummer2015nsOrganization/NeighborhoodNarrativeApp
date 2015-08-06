Rails.application.routes.draw do
  
  root "users#home"
  get "users/me", :to => "users#about", as: 'users_about'
  get "users/index", :to => "users#index", as: 'users_index'
  get "users/home", :to => "users#home", as: 'users_home'
  get "users/search", :to => "users#search", as: 'users_search'
 
  get "users/finalpage", :to => "users#finalpage", as: 'users_finalpage'
  post "users/finalpage"
end