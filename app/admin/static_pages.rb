ActiveAdmin.register StaticPage do
    permit_params :title, :content, :slug
end