class ApplicationController < ActionController::API

  def not_found
    render json: { status: :not_found }
  end
  
  def authorize_request
    header = request.headers['Authorization']
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = Student.find(@decoded[:student_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
