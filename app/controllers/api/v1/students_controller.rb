class API::V1::StudentsController < ApplicationController

  before_action :authorize_request, except: :create
  before_action :find_student, except: [:create, :index]

  def index
    @students = Student.all
    render json: @students , status: :ok
  end

  def create
    @student = Student.new(student_params)
    @user = User.new(user_params.merge(account: @student))

    if @student.save && @user.save
      render json: @student, status: :ok
    else
      render json: { errors: @student.errors.merge!(@user.errors) }, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      render json: @student, status: :ok
    else
      render json: { errors: @student.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if account_owner(@student.user)
      @student.destroy
      render json: { message: "Successfully deleted."}, status: :no_content
    else
      render json: { errors: @student.errors }, status: :unprocessable_entity
    end
  end

  private
    def student_params
      params.require(:student).permit(:first_name, :middle_name, :last_name, :gender)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def find_student
      @student = Student.find(params[:id])
    end

    def account_owner(student)
      @current_user == student
    end
end