class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  def show
    if @user
      render json: {user: {id: @user.id, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at}}, status: :ok
    else
      render json: {unauthorized: "Invalid or no credentials given"}, status: :unauthorized
    end
  end

  def create
    @user = User.find_by_email(user_params[:email]) || User.new(user_params)
    if @user.id.nil?
      if @user.save
        @user.save(validate: false)
        render json: {user: {id: @user.id, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at}}, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      if @user.errors.any?
        render json: @user.errors, status: :unprocessable_entity
      else
        render json: {error: "user already signed up"}, status: 401
      end
    end
  end

  def update
    if @user
      if @user.update(user_params)
        render json: {user: {id: @user.id, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at}}, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {unauthorized: "Invalid or no credentials given"}, status: :unauthorized
    end
  end

  private;

    def set_user
      user_id = JsonWebToken.decode(cookies[:login])["id"]
      @user = User.find(user_id) unless user_id.nil?
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
