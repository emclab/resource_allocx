Rails.application.routes.draw do

  mount ResourceAllocx::Engine => "/resource_allocx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount SwModuleInfox::Engine => '/engine'
  mount Searchx::Engine  => '/search'
  
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
  
end
