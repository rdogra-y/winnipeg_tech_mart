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

    current_user.update!(province: province)  # ✅ Save province to user

    subtotal = @cart.total
    gst = subtotal * province.gst
    pst = subtotal * province.pst
    hst = subtotal * province.hst
    total = subtotal + gst + pst + hst

    order = current_user.orders.create!(
      total: total,
      status: 'new',
      subtotal: subtotal,
      gst: gst,
      pst: pst,
      hst: hst
    )

    @cart.items.each do |item|
      OrderItem.create!(
        order: order,
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end

    @cart.clear
    redirect_to order_path(order), notice: "Order placed successfully!"
  end

  # ✅ Optional: Legacy Stripe charge support
  def charge
    @cart = Cart.new(session)
    province = current_user.province
    subtotal = @cart.total
    gst = subtotal * province.gst
    pst = subtotal * province.pst
    hst = subtotal * province.hst
    total = subtotal + gst + pst + hst

    charge = Stripe::Charge.create(
      amount: (total * 100).to_i,
      currency: 'usd',
      source: params[:stripeToken],
      description: "Order for #{current_user.email}"
    )

    order = current_user.orders.create!(
      total: total,
      stripe_payment_id: charge.id,
      paid: true,
      status: 'paid',
      subtotal: subtotal,
      gst: gst,
      pst: pst,
      hst: hst
    )

    @cart.items.each do |item|
      order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end

    @cart.clear
    redirect_to order_path(order), notice: 'Payment successful! Order placed.'
  rescue Stripe::CardError => e
    redirect_to new_checkout_path, alert: e.message
  end

  # ✅ Stripe Checkout Session flow
  def create_checkout_session
    @cart = Cart.new(session)
    province = Province.find_by(id: params[:province_id]) || current_user.province
  
    return redirect_to new_checkout_path, alert: "Please select a province." if province.nil?
  
    subtotal = @cart.total
    gst = subtotal * province.gst
    pst = subtotal * province.pst
    hst = subtotal * province.hst
    total = subtotal + gst + pst + hst
  
    # Save unpaid order before Stripe session
    order = current_user.orders.create!(
      subtotal: subtotal,
      gst: gst,
      pst: pst,
      hst: hst,
      total: total,
      status: "unpaid"
    )
  
    @cart.items.each do |item|
      order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end
  
    current_user.update!(province: province)
  
    session_obj = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      mode: 'payment',
      line_items: @cart.items.map do |item|
        {
          price_data: {
            currency: 'usd',
            product_data: { name: item[:product].name },
            unit_amount: (item[:product].price * 100).to_i
          },
          quantity: item[:quantity]
        }
      end,
      success_url: "#{checkout_success_url}?order_id=#{order.id}",
      cancel_url: "#{root_url}checkout/new"
    )
  
    redirect_to session_obj.url, allow_other_host: true
  end  

  # Handles Stripe redirect after successful payment
  def success
    @cart = Cart.new(session)
    order = current_user.orders.find_by(id: params[:order_id])
  
    if order.nil?
      redirect_to root_path, alert: "Order not found. Please contact support."
      return
    end
  
    order.update!(paid: true, status: 'paid')
    @cart.clear
  
    redirect_to order_path(order), notice: "Payment successful! Order placed."
  end  
end
