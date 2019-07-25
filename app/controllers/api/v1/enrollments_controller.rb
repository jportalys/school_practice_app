class API::V1::EnrollmentsController < ApplicationController

  before_action :authorize_request
  before_action :set_student, only: :index
  before_action :check_student_account, except: :index

  def index
    @courses = @student.courses
    render json: @courses, status: :ok
  end

  def create
    @course = Course.find_by_id(params[:course_id])
    student = @current_user.account

    if @course&.enroll(student)
      render json: @course, status: :ok
    else
      render json: { errors: "Unprocessabe entity" }, status: :unprocessable_entity
    end
  end

  def destroy
    @enrollment = Enrollment.find_by_id(params[:enrollment_id])

    if @enrollment&.unenroll(@current_user.account)
      render json: @enrollment.course, status: :no_content
    else
      render json: { errors: "Unprocessabe entity" }, status: :unprocessable_entity
    end
  end

  private
    def set_student
      @student = Student.find(params[:student_id])
    end

    def check_student_account
      unless @current_user.account_type_is_student
        return render json: { message: "Not found" }, status: :not_found
      end
    end
end
