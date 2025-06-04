class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  # ✅ Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # ✅ Ransack settings
  def self.ransackable_attributes(auth_object = nil)
    %w[id name description price stock_quantity created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category image_attachment image_blob]
  end
end
