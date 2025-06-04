class Category < ApplicationRecord
  has_many :products

  # ✅ Validations
  validates :name, presence: true
  validates :description, presence: true

  # ✅ Ransack settings
  def self.ransackable_attributes(auth_object = nil)
    %w[id name description created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end
end
