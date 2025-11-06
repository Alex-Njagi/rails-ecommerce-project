class CartsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /cart
  def show
    @cart = Cart.find_by(user_id: session[:user_id])
    if @cart
      render json: @cart
    else
      render json: { message: "Cart not found" }, status: :not_found
    end
  end

  # POST /cart/add_item
  def add_item
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    # find product
    product = Product.find(product_id)
    return render json: { error: "Product not found" }, status: :not_found unless product

    # find or create cart
    cart = Cart.find_or_create_by(user_id: session[:user_id])

    # check if item already exists in the cart
    existing_item = cart.cartItems.find { |item| item["productID"] == product_id }

    if existing_item
      existing_item["selectedQuantity"] += quantity
      existing_item["productTotal"] = existing_item["selectedQuantity"] * product.productPrice
    else
      cart.cartItems << {
        "productID" => product_id,
        "selectedQuantity" => quantity,
        "productTotal" => product.productPrice * quantity
      }
    end

    # update total
    cart.recalc_total
    cart.save

    render json: { message: "Item added to cart", cart: cart }, status: :ok
  end

  # DELETE /cart/clear
  def clear
    cart = Cart.find_by(user_id: session[:user_id])
    if cart
      cart.cartItems.clear
      cart.cartTotal = 0
      cart.save
      render json: { message: "Cart cleared" }, status: :ok
    else
      render json: { message: "Cart not found" }, status: :not_found
    end
  end
end

end
