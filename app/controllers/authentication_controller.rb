class AuthenticationController < ApplicationController

  before_action :authorize_request, only: :logout

  # POST /auth/login
  def login
    @user = User.find_by(email: login_params[:email])

    if @user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-$d-%Y %H:%M")}
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # POST /auth/logout
  def logout
    token = request.headers['Authorization']

    unless token.empty? || @current_user.nil?
      invalid_auth_token = InvalidAuthToken.create(token: token, expiry: JsonWebToken.decode(token)[:exp])
      render json: { message: "You successfully logged out" }, status: :no_content
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  private
    def login_params
      params.permit(:email, :password)
    end
end
