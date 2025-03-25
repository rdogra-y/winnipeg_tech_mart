require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(URI.open("http://books.toscrape.com/"))

category = Category.find_or_create_by(name: "Books")

doc.css('.product_pod').each do |product|
  name = product.at_css('h3 a')['title']
  price = product.at_css('.price_color').text.gsub(/[^\d\.]/, '').to_f
  description = "Imported from Books to Scrape"

  Product.create!(
    name: name,
    description: description,
    price: price,
    stock_quantity: rand(5..20),
    category: category
  )
end
