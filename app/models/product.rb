class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  # Field definition
  field :productName, type: String
  field :productCategory, type: String
  field :productPrice, type: Integer
  field :productImage, type: String
  field :productDescription, type: String
end
