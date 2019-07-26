require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let(:student) { create(:student_user) }

  describe "GET /auth/logout" do
    context "with authenticated user" do
      it "stores user JWT to blacklist" do
        @auth_token = login(student.user)

        expect{
          post logout_path, headers: { 'Authorization' => @auth_token }
        }.to change(InvalidAuthToken, :count).by(1)
      end
    end
  end

  describe "GET /auth/login", current: true do
    it "does not allow login when token is in the invalid_auth_token blacklist after logout" do
      #login user
      @auth_token = login(student.user)

      #logout
      post logout_path, headers: { 'Authorization' => @auth_token }

      #login again using same token
      get api_v1_students_path, headers: { 'Authorization' => @auth_token }
      expect(response).to be_unauthorized
    end
  end
end