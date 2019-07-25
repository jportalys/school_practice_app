require 'rails_helper'

RSpec.describe "API::V1::Courses", type: :request do
  let(:student) { create(:student_user) }
  let(:course) { create(:course, school: create(:school_user)) }

  describe "GET student/:id/courses" do
    context "with authenticated user" do
      before(:each) do
        @auth_token = login(student.user)
        @course = create(:course, school: create(:school_user))
        create(:enrollment, course: @course, student: student)
      end

      it "returns only the courses enrolled to student" do
        create(:course, title: "Other course", school: create(:school))

        get api_v1_student_courses_path(student), headers: { 'Authorization' => @auth_token }
        result_titles = JSON.parse(response.body).map{|h| h["title"]}

        expect(result_titles).to match_array([@course.title])
      end

      it "returns courses json schema" do
        get api_v1_student_courses_path(student), headers: { 'Authorization' => @auth_token }
        expect(response).to match_response_schema('student_courses')
      end
    end
    
    context "unathenticated course" do
      it "returns unathorized access" do
        get api_v1_student_courses_path(student)
        expect(response).to be_unauthorized
      end
    end
  end

  describe "POST schools/:school_id/courses/:course_id/enroll" do 
    context "with authenticated user" do
      before(:each) do
        @auth_token = login(student.user)
      end
    
      it "creates new enrollment" do
        expect {
          post api_v1_enroll_course_path(course), headers: { 'Authorization' => @auth_token }
        }.to change(Enrollment, :count).by(1)
      end

      it "returns the created course" do
        post api_v1_enroll_course_path(course), headers: { 'Authorization' => @auth_token }
        expect(response).to match_response_schema('course')
      end

      it "returns 404 when use is not a student" do
        @auth_token = login(create(:school_user).user)

        post api_v1_enroll_course_path(course), headers: { 'Authorization' => @auth_token }
        expect(response).to have_http_status(404)
      end

      it "returns 404 when course is not found" do
        post api_v1_enroll_course_path(course_id: "unregistered_course"), headers: { 'Authorization' => @auth_token }
        expect(response).to have_http_status(422)
      end
    end

    context "with unathenticated user" do
      it "returns unathorized access" do
        post api_v1_enroll_course_path(course), headers: { 'Authorization' => @auth_token }
        expect(response).to be_unauthorized
      end
    end
  end

  describe "DELETE schools/:school_id/courses/:course_id/unenroll" do
    context "with authenticated user" do
      before(:each) do
        @auth_token = login(student.user)
      end

      it "deletes the enrollment" do
        enrollment = create(:enrollment, course: course, student: student)

        expect{
          delete api_v1_unenroll_course_path(enrollment), headers: { 'Authorization' => @auth_token }
        }.to change(Enrollment, :count).by(-1)
      end

      it "only deletes enrollments that belongs to user" do
        enrollment = create(:enrollment, course: course, student: student)
        other_enrollment = create(:enrollment, course: course, student: create(:student_user))

        expect{
          delete api_v1_unenroll_course_path(other_enrollment), headers: { 'Authorization' => @auth_token }
        }.to change(Enrollment, :count).by(0)
      end

      it "returns 404 when course is not found" do
        delete api_v1_unenroll_course_path(enrollment_id: "unregistered_enrollment"), headers: { 'Authorization' => @auth_token }
        expect(response).to have_http_status(422)
      end

      it "returns no content status" do
        enrollment = create(:enrollment, course: course, student: student)

        delete api_v1_unenroll_course_path(enrollment), headers: { 'Authorization' => @auth_token }
        expect(response).to be_no_content
      end
    end

    context "with unauthenticated user", current: true do
      before(:each) do
        @enrollment = create(:enrollment, course: course, student: student)
      end

      it "does not unenroll the student" do
        expect{
          delete api_v1_unenroll_course_path(@enrollment)
        }.to change(Enrollment, :count).by(0)
      end

      it "returns :unprocessable_entity status" do
        delete api_v1_unenroll_course_path(@enrollment)
        expect(response).to be_unauthorized
      end
    end
  end
end
