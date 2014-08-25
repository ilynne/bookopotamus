Rails.application.routes.draw do

  post 'users/impersonate' => 'users#impersonate', as: :impersonate
  get 'users/stop_impersonating' => 'users#stop_impersonating', as: :stop_impersonating
  get 'users' => 'users#index'
  patch 'users/:id' => 'users#update'
  post 'users/admin' => 'users#create'
  post 'users/invite' => 'users#invite'
  get 'emailprefs/:id' => 'email_prefs#show', as: :email
  post 'emailprefs/:id' => 'email_prefs#update', as: :email_settings
  get 'ratings/index'
  get 'books/users/:user_id' => 'books#user', as: :books_user

  devise_for :users

  resources :books do
    resources :ratings, only: [:update, :new]
  end
  resources :follows, only: [:update, :new, :create, :destroy]
  resources :reviews
  resources :authors

  root 'books#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
