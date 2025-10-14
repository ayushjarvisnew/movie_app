class UsersController < ApplicationController
  before_action :authorize_request
  before_action :require_admin, only: [:index, :destroy, :update]

  def index
    render json: User.all.as_json(only: [:id, :name, :email, :is_admin])
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { message: "User deleted" }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_admin, :password, :password_confirmation)
  end
end