ActiveAdmin.register Category do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  ActiveAdmin.register Category do
    permit_params :name, :description
  
    index do
      selectable_column
      id_column
      column :name
      column :description
      column :created_at
      actions
    end
  
    form do |f|
      f.inputs "Category Details" do
        f.input :name
        f.input :description
      end
      f.actions
    end
  end
  
end
