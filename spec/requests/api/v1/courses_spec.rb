require 'rails_helper'

RSpec.describe "API::V1::Courses", type: :request do
  let(:school) { create(:school_user) }
  let(:course) { create(:course, school: school) }

  describe "GET school/:school_id/courses" do
    context "with authenticated user" do
      before(:each) do
        @auth_token = login(school.user)
      end

      it "returns courses json schema" do
        get api_v1_school_courses_path(school), headers: { 'Authorization' => @auth_token }
        expect(response).to match_response_schema('courses')
      end

      it "returns all courses scoped to school", current: true do
        course = create(:course, school: school)
        other_course = create(:course, school: create(:school), title: "Another course title")

        get api_v1_school_courses_path(school), headers: { 'Authorization' => @auth_token }
        result_titles = JSON.parse(response.body).map{|h| h["title"]}

        expect(result_titles).to match_array([course.title])
      end

      it "returns a success status" do
        get api_v1_school_courses_path(school), headers: { 'Authorization' => @auth_token }
        expect(response).to be_successful
      end
    end

    context "with unathenticated user" do
      it "returns unathorized access" do
        get api_v1_school_courses_path(school)
        expect(response).to be_unauthorized
      end
    end
  end

  describe "POST school/:school_id/courses" do
    context "With authenticated user" do
      before(:each) do
        @auth_token = login(school.user)
      end

      it "creates new course account" do
        expect {
          post api_v1_school_courses_path(school), params: { course: attributes_for(:course) }, headers: { 'Authorization' => @auth_token }
        }.to change(Course, :count).by(1)
      end

      it "returns the created course" do
        post api_v1_school_courses_path(school), params: { course: attributes_for(:course) }, headers: { 'Authorization' => @auth_token }
        expect(response).to match_response_schema('course')
      end

      it "returns 401 on validation" do
        invalid_course_attributes = attributes_for(:course, title: "")
        post api_v1_school_courses_path(school), params: { course: invalid_course_attributes }, headers: { 'Authorization' => @auth_token }

        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PUT school/:school_id/courses/:id" do
    let(:edited_course_info) { attributes_for(:course, title: "Edited title") }

    context "authenticated course" do
      before(:each) do
        @auth_token = login(school.user)
      end

      it "returns ok status" do
        put api_v1_school_course_path(school, course), headers: { 'Authorization' => @auth_token }, params: {course: edited_course_info}
        expect(response).to be_successful
      end

      it "updates course" do
        put api_v1_school_course_path(school, course), headers: { 'Authorization' => @auth_token }, params: {course: edited_course_info}
        course.reload

        expect(course.title).to eq "Edited title"
      end
    end

    context "unathenticated course" do
      it "does not update course info" do
        put api_v1_school_course_path(school, course), params: {course: edited_course_info}
        course.reload

        expect(course.title).to_not eq "Edited title"
      end

      it "returns :unprocessable_entity status" do
        put api_v1_school_course_path(school, course), params: {course: edited_course_info}
        expect(response).to be_unauthorized
      end
    end
  end

  describe "DELETE school/:school_id/courses/:id" do
    context "with authenticated user" do
      before(:each) do
        @auth_token = login(school.user)
      end

      it "destroys the course" do
        course = create(:course, school: school)

        expect{
          delete api_v1_school_course_path(school, course), headers: { 'Authorization' => @auth_token }
        }.to change(Course, :count).by(-1)
      end

      it "allows owner only to delete the course" do
        course = create(:course, school: school)
        other_user = create(:user, account: create(:school), email: "another_email@test.com")

        expect{
          delete api_v1_school_course_path(school, course), headers: { 'Authorization' => login(other_user) }
        }.to change(Course, :count).by(0)
      end

      it "returns no content status" do
        course = create(:course, school: school)

        delete api_v1_school_course_path(school, course), headers: { 'Authorization' => @auth_token }
        expect(response).to be_no_content
      end
    end

    context "unathenticated user" do
      it "does not destroys courses account" do
        course = create(:course, school: school)

        expect{
          delete api_v1_school_course_path(school, course)
        }.to change(Course, :count).by(0)
      end

      it "returns :unprocessable_entity status" do
        delete api_v1_school_course_path(school, course)
        expect(response).to be_unauthorized
      end
    end
  end
end
