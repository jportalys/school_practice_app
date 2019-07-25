require 'rails_helper'

RSpec.describe "API::V1::Schools", type: :request do
  let(:school_user) { create(:school_user) }

  describe "POST /schools" do
    it "registers new school" do
      school_attributes = attributes_for(:school_user)
      expect {
        post api_v1_schools_path, params: { school: school_attributes, user: attributes_for(:user) }
      }.to change(School, :count).by(1)
    end

    it "returns 401 on validation" do
      invalid_school_attributes = attributes_for(:school, name: "")
      post api_v1_schools_path, params: { school: invalid_school_attributes, user: attributes_for(:user) }

      expect(response).to have_http_status(422)
    end

    it "returns the created course" do
      post api_v1_schools_path, params: { school: attributes_for(:school_user), user: attributes_for(:user) }
      expect(response).to match_response_schema('school')
    end
  end

  describe "PUT /schools/:id" do
    let(:edited_school_info) { attributes_for(:school, name: "New Academy Name") }

    context "authenticated school" do
      before(:each) do
        @auth_token = login(school_user.user)
      end

      it "updates school" do
        put api_v1_school_path(school_user), headers: { 'Authorization' => @auth_token }, params: {school: edited_school_info}
        school_user.reload

        expect(school_user.name).to eq "New Academy Name"
      end

      it "returns :ok status" do
        put api_v1_school_path(school_user), headers: { 'Authorization' => @auth_token }, params: {school: edited_school_info}
        expect(response).to be_successful
      end
    end

    context "unathenticated school" do
      it "does not update school info" do
        put api_v1_school_path(school_user), params: {school: edited_school_info}
        school_user.reload

        expect(school_user.name).to_not eq "New Academy Name"
      end

      it "returns :unprocessable_entity status" do
        put api_v1_school_path(school_user), params: {school: edited_school_info}
        expect(response).to be_unauthorized
      end
    end
  end

  describe "DELETE /schools/:id" do
    context "authenticated school" do
      before(:each) do
        @auth_token = login(school_user.user)
      end

      it "destroys school account" do
        expect{
          delete api_v1_school_path(school_user), headers: { 'Authorization' => @auth_token }
        }.to change(School, :count).by(-1)
      end

      it "does not allow other school to delete account" do
        other_user = create(:user, account: create(:school), email: "another_email@test.com")

        expect{
          delete api_v1_school_path(other_user.account), headers: { 'Authorization' => @auth_token }
        }.to change(School, :count).by(0)
      end

      it "returns no content status" do
        delete api_v1_school_path(school_user), headers: { 'Authorization' => @auth_token }
        expect(response).to be_no_content
      end
    end

    context "unathenticated school" do
      it "does not destroys schools account" do
        user = create(:user, account: create(:school), email: "another_email@test.com")

        expect{
          delete api_v1_school_path(user.account)
        }.to change(School, :count).by(0)
      end

      it "returns :unprocessable_entity status" do
        delete api_v1_school_path(school_user)
        expect(response).to be_unauthorized
      end
    end
  end
end
