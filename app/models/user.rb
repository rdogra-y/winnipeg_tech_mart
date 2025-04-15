class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :province, optional: true
  has_many :orders

  # Validations (optional, you can customize later)
  validates :address, presence: true, if: -> { province_id.present? }
end
