Rails.application.routes.draw do
  # Admin + Devise
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Products & Categories (public browsing)
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # Editable Static Pages (Admin edits in dashboard, users view via slug)
  resources :static_pages, param: :slug, only: [:show]
  get '/:slug', to: 'static_pages#show', as: :page

  # Serve uploaded images via Active Storage (needed for image_tag)
  mount ActiveStorage::Engine => '/rails/active_storage'

  # Health checks & PWA features (optional defaults)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Homepage
  root "products#index"
end
