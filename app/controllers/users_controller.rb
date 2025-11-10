class UsersController < ApplicationController
skip_before_action :verify_authenticity_token

    def new
        @user = User.new
    end

    # GET /users
    def index
        @users = User.all
        render json: @users
    end

    # GET /users/:id
    def show
        @user = User.find(params[:id])
        render json: @user
    end

    # POST /users
    def create
        @user = User.new(user_params)
        if @user.save
            # render json: @user, status: :created
            redirect_to login_path, notice: "Account created successfully!"
        else
            redirect_to signup_path, alert: "Invalid credentials. Please try again"
        end
    end

    def login
        # renders login page
    end

    def authenticate
        user = User.find_by(email: params[:email])
        if user && user.password == params[:password] # use bcrypt later
            session[:user_id] = user.id
            # redirect_to root_path, notice: "Logged in!"
            redirect_to view_products_path, notice: "Logged in!"
        else
            redirect_to login_path, alert: "Invalid credentials. Please try again" unless session[:user_id]
        end
    end

    def logout
        session[:user_id] = nil
        redirect_to login_path, notice: "Logged out successfully!"
    end

    # PATCH/PUT /users/:id
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            render json: @user
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

  # DELETE /users/:id
    def destroy
        @user = User.find(params[:id])
        @user.destroy
        render json: { message: "User deleted successfully." }, status: :ok
    end

    private

    def user_params
        params.require(:user).permit(:firstName, :lastName, :email, :password, :phoneNumber,
                                        address: [:county, :city, :street, :postalCode])
        end
end
