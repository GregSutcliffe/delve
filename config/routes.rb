Delve::Application.routes.draw do
  root  'static_pages#home'
  match '/help',     to: 'static_pages#help',    via: 'get'
  match '/about',    to: 'static_pages#about',   via: 'get'
  match '/contact',  to: 'static_pages#contact', via: 'get'

  get "static_pages/home"

  resources :scanners do
    member do
      get 'acquire'
    end
  end

  resources :pages do
    member do
      get   'rotate'
    end
  end

  resources :documents do
    member do
      patch 'upload'
      get   'scan'
    end
  end

  get 'tags/:tag', to: 'documents#index', as: :tag

  #map.thumbnail "/scans/thumbs/:id", :controller => "images", :action => "get_thumb"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
