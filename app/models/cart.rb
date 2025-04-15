class Cart
  def initialize(session)
    @session = session
    @session[:cart] ||= {}
  end

  def self.build_from_session(session_data)
    dummy_session = { cart: session_data }
    new(dummy_session)
  end

  def add_product(product_id)
    @session[:cart][product_id.to_s] ||= 0
    @session[:cart][product_id.to_s] += 1
  end

  def remove_product(product_id)
    @session[:cart].delete(product_id.to_s)
  end

  def update_quantity(product_id, quantity)
    @session[:cart][product_id.to_s] = quantity.to_i
  end

  def items
    @session[:cart].map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity.to_i } if product
    end.compact
  end

  def total
    items.sum { |item| item[:product].price * item[:quantity] }
  end

  def clear
    @session[:cart] = {}
  end
end
