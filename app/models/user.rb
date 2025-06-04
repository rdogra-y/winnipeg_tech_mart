class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :province, optional: true
  has_many :orders

  # Validations
  validates :address, presence: true, if: -> { province_id.present? }

  # ✅ Fix for ActiveAdmin + Ransack filtering
  def self.ransackable_attributes(auth_object = nil)
    %w[id email address province_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[province orders]
  end
end
