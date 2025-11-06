class Cart
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: BSON::ObjectId
  field :cartItems, type: Array, default: []
  field :cartTotal, type: Float, default: 0.0

  belongs_to :user, optional: true

  # helper method to recalculate the cart total
  def recalc_total
    self.cartTotal = cartItems.sum { |item| item["productTotal"].to_f }
  end
end
