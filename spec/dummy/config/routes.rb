Rails.application.routes.draw do

  mount ResourceAllocx::Engine => "/resource_allocx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount SwModuleInfox::Engine => '/engine'
  mount Searchx::Engine  => '/search'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
  
end
