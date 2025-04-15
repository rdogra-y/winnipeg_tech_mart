Rails.application.routes.draw do
  # Devise for Customers and Admins
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Admin Dashboard
  ActiveAdmin.routes(self)

  resource :cart, only: [:show] do
    post   'add/:product_id',    to: 'carts#add',    as: 'add_to'
    post   'update/:product_id', to: 'carts#update', as: 'update_item'
    delete 'remove/:product_id', to: 'carts#remove', as: 'remove_item'
  end
 
  # Products & Categories
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # Editable Static Pages
  resources :static_pages, param: :slug, only: [:show]
  get '/:slug', to: 'static_pages#show', as: :page

  # Checkout
  resources :checkout, only: [:new, :create]

  # Orders
  resources :orders, only: [:index, :show]

  # Active Storage (for image uploads)
  mount ActiveStorage::Engine => '/rails/active_storage'

  # Health checks & PWA features
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Homepage
  root "products#index"
end
