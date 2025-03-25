require 'csv'

csv_file_path = Rails.root.join("products.csv")

CSV.foreach(csv_file_path, headers: true) do |row|
  category = Category.find_or_create_by(name: row['category'])

  Product.create!(
    name: row['name'],
    description: row['description'],
    price: row['price'].to_f,
    stock_quantity: row['stock_quantity'].to_i,
    category: category
  )
end

puts "✅ Products imported from CSV!"
