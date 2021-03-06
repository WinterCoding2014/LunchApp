Rails.application.routes.draw do

  get 'ratings/set'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  LunchApp::Application.routes.draw do

    resources :venues
    # resources :ratings
    resources :sessions, only: [:new, :create]

    put '/venues/:venue_id/ratings' => 'ratings#set'

    get '/sessions/destroy' => 'sessions#destroy'

    get '/venues/winner/get_winner' => 'venues#get_set_winner'

    get '/venues/order/orders' => 'venues#order_list'

    get '/venues/order/order' => 'orders#get'

    put '/venues/order/place_order' => 'orders#set'

    get '/venues/attendee_status/get' => 'lunch_attendees#get'

    put '/venues/attendee_status/set' => 'lunch_attendees#set'

    get '/venues/happy_status/status' => 'venues#am_i_unhappy'


    root 'venues#index'
  end

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
