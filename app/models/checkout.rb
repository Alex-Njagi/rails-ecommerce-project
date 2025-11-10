# app/models/checkout.rb
class Checkout
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: BSON::ObjectId
  field :cart_id, type: BSON::ObjectId
  field :cartItems, type: Array, default: []
  field :cartTotal, type: Float
  field :deliveryFees, type: Float, default: 300.0
  field :totalFees, type: Float
  field :paymentMethod, type: String
  field :paymentNumber, type: String
  field :deliveryDate, type: Date
  field :deliveryInformation, type: Hash

  belongs_to :user, optional: true
  belongs_to :cart, optional: true

  before_create :set_delivery_date, :calculate_total_fees

  private

  def set_delivery_date
    self.deliveryDate = Date.today + 3
  end

  def calculate_total_fees
    self.totalFees = (cartTotal || 0) + (deliveryFees || 0)
  end
end
