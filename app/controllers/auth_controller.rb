class AuthController < ApplicationController
  before_action :authorize_request, only: [:current_user]

  def current_user
    render json: @current_user ? { user: user_response(@current_user) } : { user: nil }
  end

  def signup
    user = User.new(user_params)
    user.save!
    token = encode_token(user)
    render json: { user: user_response(user), token: token }, status: :created
  rescue => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token(user)
      render json: { user: user_response(user), token: token }, status: :ok
    else
      render json: { errors: ["Invalid email or password"] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :phone, :is_admin)
  end

  def user_response(user)
    { id: user.id, name: user.name, email: user.email, phone: user.phone, is_admin: user.is_admin }
  end
end