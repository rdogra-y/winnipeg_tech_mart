class CartsController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = Product.where(id: session[:cart].keys)
  end

  def add
    id = params[:product_id].to_s
    session[:cart][id] ||= 0
    session[:cart][id] += 1
    redirect_to cart_path, notice: "Product added to cart."
  end

  def remove
    session[:cart].delete(params[:product_id].to_s)
    redirect_to cart_path, notice: "Product removed from cart."
  end

  def update_quantity
    id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    session[:cart][id] = quantity > 0 ? quantity : nil
    redirect_to cart_path, notice: "Quantity updated."
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end
end
