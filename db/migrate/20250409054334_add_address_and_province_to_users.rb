class AddAddressAndProvinceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :address, :string
    add_reference :users, :province, null: false, foreign_key: true
  end
end
