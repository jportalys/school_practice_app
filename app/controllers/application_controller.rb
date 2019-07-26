class ApplicationController < ActionController::API

  def not_found
    render json: { status: :not_found }
  end

  def authorize_request
    token = request.headers['Authorization']
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
      InvalidAuthToken.crosscheck(token)
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end