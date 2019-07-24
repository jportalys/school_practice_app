class API::V1::StudentsController < ApplicationController

  before_action :authorize_request, except: :create
  before_action :find_student, except: [:create, :index]

  def index
    @students = Student.all
    render json: @students , status: :ok
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      render json: @student, status: :ok
    else
      render json: { errors: @student.errors }, status: :unprocessable_entity
    end
  end

  def update    
    if @student.update!(student_params)
      render json: @student, status: :ok
    else
      render json: { errors: @student.errors }, status: :unprocessable_entity      
    end
  end

  def destroy
    if account_owner(@student)
      @student.destroy
      render json: { message: "Successfully deleted."}, status: :ok
    else
      render json: { errors: @student.errors }, status: :unprocessable_entity
    end
  end

  private
    def student_params
      params.require(:student).permit(:email, :first_name, :middle_name, :last_name, :gender, :password, :password_confirmation)
    end

    def find_student
      @student = Student.find(params[:id])
    end

    def account_owner(student)
      @current_user == student
    end
end