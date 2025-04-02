class Category < ApplicationRecord
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end
end
