ResourceAllocx::Engine.routes.draw do

  resources :allocations

  root :to => 'allocations#index'
end

