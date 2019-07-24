class AuthenticationController < ApplicationController

  # POST /auth/login
  def login
    @student = Student.find_by(email: login_params[:email])

    if @student&.authenticate(params[:password])
      token = JsonWebToken.encode(student_id: @student.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-$d-%Y %H:%M")}
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private
    def login_params
      params.permit(:email, :password)
    end
end
