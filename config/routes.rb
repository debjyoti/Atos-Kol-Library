AoiLib::Application.routes.draw do
  authenticated :user do
    root :to => 'profiles#show'
  end
  root :to => redirect('/users/sign_in')

  resources :books do
    put 'send_request'
    put 'issue_to_user'
    put 'return_to_library'
    put 'cancel_request'
    put 'renew_duration'
    put 'block_for_future'
    put 'unblock'
    get 'show_issue_history'
    put 'bring_back'

    collection do
      get 'filter_category'
      get 'manage'
      get 'show_pending_approvals'
      get 'show_issued'
    end
  end

  resources :profiles, :except => [:new, :create] do
    put 'approve_user'
    put 'toggle_admin_rights'
    get 'show_issue_history'
    collection do
      get 'show_fines'
      post 'charge_fine'
      post 'spend_money'
      put 'migrate_user'
    end
  end
  devise_for :users 

  resources :categories


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
