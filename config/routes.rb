ResourceAllocx::Engine.routes.draw do

  resources :alloctions

  root :to => 'allocations#index'
end

