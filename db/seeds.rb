# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Create default admin user for development
if Rails.env.development?
    AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
      admin.password = 'password'
      admin.password_confirmation = 'password'
    end
  end
  
  puts "✅ Admin user created."
  
  # Clear existing products and categories
  Product.destroy_all
  Category.destroy_all
  
  puts "🧹 Cleared old products and categories."
  
  # Create 4 categories
  category_names = ["Laptops", "Phones", "Headphones", "Accessories"]
  categories = category_names.map do |name|
    Category.find_or_create_by!(name: name, description: "All kinds of #{name}")
  end
  
  puts "📦 Created categories: #{category_names.join(', ')}"
  
  # Create 100 fake products
  100.times do
    Product.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph(sentence_count: 2),
      price: Faker::Commerce.price(range: 50..2000),
      stock_quantity: rand(5..50),
      category: categories.sample
    )
  end
  
  puts "🛍️  Created 100 fake products."
  