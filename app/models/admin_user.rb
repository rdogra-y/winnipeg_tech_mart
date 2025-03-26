class AdminUser < ApplicationRecord
  # Devise modules...
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # Fix for Ransack / ActiveAdmin search filter
  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at]
  end
end
