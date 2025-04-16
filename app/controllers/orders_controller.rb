class OrdersController < ApplicationController
  before_action :authenticate_user! # ensures user is logged in

  def new
    @order = Order.new
    @cart_items = Product.where(id: session[:cart].keys)
  end

  def create
    session_cart = session[:cart] || {}
    @order = current_user.orders.build(status: "new")
    subtotal = 0

    session_cart.each do |product_id, qty|
      product = Product.find_by(id: product_id)
      next unless product

      quantity = qty.to_i
      next if quantity <= 0

      subtotal += product.price * quantity

      @order.order_items.build(
        product: product,
        quantity: quantity,
        price: product.price
      )
    end

    province = current_user.province
    gst = province&.gst.to_f || 0
    pst = province&.pst.to_f || 0
    hst = province&.hst.to_f || 0

    total_tax = subtotal * (gst + pst + hst)
    @order.total = subtotal + total_tax

    if @order.save
      session[:cart] = {}
      redirect_to @order, notice: "Order placed successfully!"
    else
      flash[:alert] = "Order could not be placed."
      render :new
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
  
end
