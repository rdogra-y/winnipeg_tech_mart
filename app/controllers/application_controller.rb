class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_stripe_publishable_key  # ✅ Add this line to set key globally

  protected

  def configure_permitted_parameters
    # ✅ These allow users to set address and province during signup or update
    devise_parameter_sanitizer.permit(:sign_up, keys: [:address, :province_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:address, :province_id])
  end

  def set_stripe_publishable_key
    @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end
end
