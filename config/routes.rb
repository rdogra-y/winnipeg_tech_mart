Rails.application.routes.draw do
  # Admin + Devise
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Products & Categories (used in public browsing)
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # Editable Static Pages (1.4)
  # Admin will manage creation/editing of these pages
  # Users can access them via clean URLs like /about or /contact
  resources :static_pages, param: :slug, only: [:show]
  get '/:slug', to: 'static_pages#show', as: :page

  # Health & PWA (default Rails 7 routes)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Home page (update as needed)
  root "products#index"
end
