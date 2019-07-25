class API::V1::CoursesController < ApplicationController

  before_action :authorize_request
  before_action :set_school
  before_action :set_course, except: [:index, :create]

  def index
    @courses = @school.courses
    render json: @courses, status: :ok
  end

  def create
    @course = @school.courses.create(course_params)
    if @course.persisted?
      render json: @course, status: :ok
    else
      render json: { errors: @course.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      render json: @course, status: :ok
    else
      render json: { errors: @course.errors }, status: :unprocessable_entity      
    end
  end
  
  def destroy
    if course_owner(@course)
      @course.destroy
      render json: { message: "Successfully deleted."}, status: :no_content
    else
      render json: { errors: @school.errors }, status: :unprocessable_entity
    end
  end

  private
    def course_params
      params.require(:course).permit(:title, :description)
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    def set_course
      @course = @school.courses.find(params[:id])
    end

    def course_owner(course)
      @current_user.account_type_is_school && (@current_user.account_id == course.school_id)
    end
end