class Province < ApplicationRecord
  has_many :users

  # ✅ Validations
  validates :name, presence: true, uniqueness: true
  validates :gst, :pst, :hst,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  def total_tax_rate
    gst.to_f + pst.to_f + hst.to_f
  end

  # ✅ Required for ActiveAdmin/Ransack filtering
  def self.ransackable_attributes(auth_object = nil)
    ["name", "gst", "pst", "hst", "created_at", "updated_at", "id"]
  end
end
