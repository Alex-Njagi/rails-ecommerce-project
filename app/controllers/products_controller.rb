class ProductsController < ApplicationController
skip_before_action :verify_authenticity_token
    # GET /products
    def products
        @products = Product.all
        # render json: @products, except: [:created_at, :updated_at]
    end
    
    # GET /products/:id
    def show
        @product = Product.find(params[:id])
        # render json: @product, except: [:created_at, :updated_at]
    end
end
