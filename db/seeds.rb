# # This file should ensure the existence of records required to run the application in every environment (production,
# # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Example:
# #
# #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
# #     MovieGenre.find_or_create_by!(name: genre_name)
# #   end
# # Create default admin user for development
# if Rails.env.development?
#     AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
#       admin.password = 'password'
#       admin.password_confirmation = 'password'
#     end
#   end
  
#   puts "✅ Admin user created."
  
#   # Clear existing products and categories
#   Product.destroy_all
#   Category.destroy_all
  
#   puts "🧹 Cleared old products and categories."
  
#   # Create 4 categories
#   category_names = ["Laptops", "Phones", "Headphones", "Accessories"]
#   categories = category_names.map do |name|
#     Category.find_or_create_by!(name: name, description: "All kinds of #{name}")
#   end
  
#   puts "📦 Created categories: #{category_names.join(', ')}"
  
#   # Create 100 fake products
#   100.times do
#     Product.create!(
#       name: Faker::Commerce.product_name,
#       description: Faker::Lorem.paragraph(sentence_count: 2),
#       price: Faker::Commerce.price(range: 50..2000),
#       stock_quantity: rand(5..50),
#       category: categories.sample
#     )
#   end
  
#   puts "🛍️  Created 100 fake products."
require 'csv'
require 'open-uri'
require 'json'

# Create default admin user for development
if Rails.env.development?
  AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
  end
end

puts "✅ Admin user created."

# Clear existing data
Product.destroy_all
Category.destroy_all
puts "🧹 Cleared old products and categories."

# -------------------
# 1.8 Load from CSV
# -------------------
csv_path = Rails.root.join("db", "data", "products.csv")

if File.exist?(csv_path)
  csv_data = CSV.read(csv_path, headers: true)
  csv_data.each do |row|
    category = Category.find_or_create_by!(name: row["Category"]) do |cat|
      cat.description = "Imported from CSV"
    end

    Product.create!(
      name: row["Name"],
      description: row["Description"],
      price: row["Price"],
      stock_quantity: row["Stock Quantity"],
      category: category
    )
  end
  puts "📂 Loaded #{csv_data.size} products from CSV file."
else
  puts "⚠️ CSV file not found at #{csv_path}"
end

# -------------------------------
# 1.7 Scrape or API sample (fake)
# -------------------------------
# Example: Pull products from a sample fake JSON API
api_url = "https://fakestoreapi.com/products"
api_products = URI.open(api_url).read
products_data = JSON.parse(api_products)

products_data.each do |item|
  category = Category.find_or_create_by!(name: item["category"]) do |cat|
    cat.description = "API-imported category"
  end

  Product.create!(
    name: item["title"],
    description: item["description"],
    price: item["price"],
    stock_quantity: rand(10..30),
    category: category
  )
end

puts "🌐 Fetched and created #{products_data.size} products from API."
