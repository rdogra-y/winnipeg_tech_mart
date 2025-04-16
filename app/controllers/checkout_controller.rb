class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = Cart.new(session)
    @provinces = Province.all

    @province = params[:province_id].present? ? Province.find_by(id: params[:province_id]) : current_user.province || @provinces.first

    @subtotal = @cart.total
    @gst = @province.gst || 0
    @pst = @province.pst || 0
    @hst = @province.hst || 0
    @total = @subtotal * (1 + @gst + @pst + @hst)
  end

  def create
    @cart = Cart.new(session)
    province = Province.find(params[:province_id])

    # ✅ Update user's province (for 3.1.5)
    current_user.update!(province: province)

    subtotal = @cart.total
    gst = subtotal * province.gst
    pst = subtotal * province.pst
    hst = subtotal * province.hst
    total = subtotal + gst + pst + hst

    order = current_user.orders.create!(
      total: total,
      status: 'new'
    )

    @cart.items.each do |item|
      OrderItem.create!(
        order: order,
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end

    # ✅ Clear cart after successful order
    @cart.clear

    redirect_to order_path(order), notice: "Order placed successfully!"
  end
end
