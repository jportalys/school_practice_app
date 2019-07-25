class API::V1::SchoolsController < ApplicationController

    before_action :authorize_request, except: :create
    before_action :find_school, except: [:create, :index]
    
    def create
      @school = School.new(school_params)
      @user = User.new(user_params.merge(account: @school))
  
      if @school.save && @user.save
        render json: @school, status: :ok
      else
        render json: { errors: @school.errors.merge!(@user.errors) }, status: :unprocessable_entity
      end
    end
  
    def update
      if @school.update(school_params)
        render json: @school, status: :ok
      else
        render json: { errors: @school.errors }, status: :unprocessable_entity      
      end
    end
  
    def destroy
      if account_owner(@school.user)
        @school.destroy
        render json: { message: "Successfully deleted."}, status: :no_content
      else
        render json: { errors: @school.errors }, status: :unprocessable_entity
      end
    end
  
    private
      def school_params
        params.require(:school).permit(:email, :name, :password, :password_confirmation)
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    
      def find_school
        @school = School.find(params[:id])
      end
  
      def account_owner(school)
        @current_user == school
      end
end
