json.extract! static_page, :id, :title, :content, :slug, :created_at, :updated_at
json.url static_page_url(static_page, format: :json)
