class Province < ApplicationRecord
    has_many :users
  
    def total_tax_rate
      gst.to_f + pst.to_f + hst.to_f
    end
  end
  