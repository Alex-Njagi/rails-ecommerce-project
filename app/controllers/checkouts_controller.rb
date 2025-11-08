class CheckoutsController < ApplicationController
skip_before_action :verify_authenticity_token
  before_action :require_login

  def new
    user = User.find(session[:user_id])
    cart = Cart.find_by(user_id: user.id)

    if cart.nil? || cart.cartItems.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @checkout = Checkout.new(
      user_id: user.id,
      cart_id: cart.id,
      cartTotal: cart.cartTotal,
      paymentNumber: user.phoneNumber,
      deliveryInformation: user.address
    )
  end

  def create
    @checkout = Checkout.new(checkout_params)
    @checkout.user_id = session[:user_id]
    @checkout.cart_id = Cart.find_by(user_id: session[:user_id])&.id
    @checkout.cartTotal = Cart.find_by(user_id: session[:user_id])&.cartTotal

    if @checkout.save
      redirect_to checkout_confirmation_path(@checkout.id), notice: "Order placed successfully!"
    else
      render :new, alert: "Something went wrong. Please try again."
    end
  end

  def show
    @checkout = Checkout.find(params[:id])
  end

  private

  def checkout_params
    params.require(:checkout).permit(:paymentMethod, :paymentNumber, deliveryInformation: [:county, :city, :street, :postalCode])
  end

  def require_login
    redirect_to login_path, alert: "You must be logged in to checkout." unless session[:user_id]
  end
end
