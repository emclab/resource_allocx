ResourceAllocx::Engine.routes.draw do

  resources :allocations do
    collection do
      get :multi_csv
      get :multi_csv_result
    end
  end

  root :to => 'allocations#index'
end

