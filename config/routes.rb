GlossaryMaker::Application.routes.draw do
  get "glossaries/new"

  root to:'static_pages#home'
  
  resources :users, only: [:create, :new]
  
  match '/help', to:'static_pages#help'
  match '/about', to:'static_pages#about'

  if Rails.env.test?
    match '/login', to: 'sessions#new', as: 'login', via: 'get'
    match '/login', to: 'sessions#create', as: 'create_sessions', via: 'post'
  end
  match '/logout', to: 'sessions#destroy'

  match '/user/edit', to: 'users#edit', as: "edit_user", via: 'get'
  match '/user/edit', to: 'users#update', as: "update_user", via: 'post'
  match '/user/delete_confirm', to: 'users#delete_confirm', as: "delete_confirm_user", via: 'get'
  match '/user/delete', to: 'users#delete', as: "delete_user", via: 'post'
  match '/user/(:id)', to: 'users#show', as: 'user', via: 'get'
  
  resources :glossaries, path: "/g/", only: [:new, :create]
  match '/g/(:name)', to: 'glossaries#show', as: "glossary", via: "get"
  match '/g/(:name)/edit', to: 'glossaries#edit', as: "edit_glossary", via: "get"
  match '/g/(:name)', to: 'glossaries#update', as: "update_glossary", via: "put"
  match '/g/(:name)/delete', to: 'glossaries#delete', as: "delete_glossary", via: "post"
  
  match '/g/(:name)/new', to: 'words#new', as: "new_word", via: "get"
  match '/g/(:name)/new', to: 'words#create', as: "create_word", via: "post"
  match '/g/(:name)/(:id)', to: 'words#edit', as: "edit_word", via: "get"
  match '/g/(:name)/(:id)', to: 'words#update', as: "update_word", via: "post"
  match '/g/(:name)/(:id)/delete', to: 'words#delete', as: "delete_word", via: "post"
  match '/g/(:name)/(:id)/star', to: 'words#star', as: "star_word", via: "post"
  match '/g/(:name)/(:id)/unstar', to: 'words#unstar', as: "unstar_word", via: "post"

  match '/auth/:provider/callback', to: 'auth#callback'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
