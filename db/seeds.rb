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

# Clear existing data (optional if needed)
# Product.destroy_all
# Category.destroy_all
# puts "🧹 Cleared old products and categories."

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
  puts "📦 Loaded #{csv_data.size} products from CSV file."
else
  puts "⚠️ CSV file not found at #{csv_path}"
end

# -------------------------------
# 1.7 Scrape or API sample (fake)
# -------------------------------
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

# --------------------------
# ✅ Add provinces (Expanded for 3.2.3)
# --------------------------
# Province.destroy_all
Province.create!([
  { name: "Alberta", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "British Columbia", gst: 0.05, pst: 0.07, hst: 0.0 },
  { name: "Manitoba", gst: 0.05, pst: 0.07, hst: 0.0 },
  { name: "New Brunswick", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Newfoundland and Labrador", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Nova Scotia", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Ontario", gst: 0.0, pst: 0.0, hst: 0.13 },
  { name: "Prince Edward Island", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Quebec", gst: 0.05, pst: 0.09975, hst: 0.0 },
  { name: "Saskatchewan", gst: 0.05, pst: 0.06, hst: 0.0 },
  { name: "Northwest Territories", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "Nunavut", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "Yukon", gst: 0.05, pst: 0.0, hst: 0.0 }
])

puts "🏷️ Seeded all Canadian provinces and territories with tax rates."
