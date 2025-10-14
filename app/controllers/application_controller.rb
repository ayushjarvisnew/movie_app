class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  attr_reader :current_user                  #getter

  private

  # Decode and authorize user from JWT
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')[0]
      @current_user = User.find(decoded["user_id"])
      @current_username = decoded["user_name"]
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { errors: ["Not Authorized"] }, status: :unauthorized
    end
  end

  # Restrict certain actions to admins
  def require_admin
    unless @current_user&.is_admin
      render json: { errors: ["Admin access required"] }, status: :forbidden
    end
  end

  def encode_token(payload)
    if payload.is_a?(User)
      payload = { user_id: payload.id, user_name: payload.name }
    end
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
end