ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :stock_quantity
    column :category
    column "Image" do |product|
      if product.image.attached?
        image_tag url_for(product.image.variant(resize_to_limit: [100, 100])), height: '50'
      else
        "No image"
      end
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category
      f.input :image, as: :file
    end
    f.actions
  end
end
