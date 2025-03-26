class StaticPage < ApplicationRecord

    def self.ransackable_attributes(auth_object = nil)
      %w[title slug content created_at updated_at]
    end
  end
  