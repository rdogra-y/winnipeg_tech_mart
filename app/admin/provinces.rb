ActiveAdmin.register Province do
  permit_params :name, :gst, :pst, :hst

  index do
    selectable_column
    id_column
    column :name
    column :gst
    column :pst
    column :hst
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end
end
