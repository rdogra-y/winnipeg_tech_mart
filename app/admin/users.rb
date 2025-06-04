ActiveAdmin.register User do
    permit_params :email, :password, :password_confirmation, :address, :province_id
  
    index do
      selectable_column
      id_column
      column :email
      column :address
      column :province
      column :created_at
      actions
    end
  
    filter :email
    filter :province
    filter :created_at
  
    form do |f|
      f.inputs "User Details" do
        f.input :email
        f.input :password
        f.input :password_confirmation
        f.input :address
        f.input :province, as: :select, collection: Province.all.map { |p| [p.name, p.id] }
      end
      f.actions
    end
  end
  