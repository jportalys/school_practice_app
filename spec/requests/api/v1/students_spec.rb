require 'rails_helper'

RSpec.describe "API::V1::Students", type: :request do
  let(:student) { create(:student) }

  describe "GET /students" do
    context "authenticated student" do
      before(:each) do
        @auth_token = login(student)
      end

      it "returns all students" do
        get api_v1_students_path, headers: { 'Authorization' => @auth_token }
        expect(response).to match_response_schema('student')
      end

      it "returns a success status" do
        get api_v1_students_path, headers: { 'Authorization' => @auth_token }
        expect(response).to be_successful
      end
    end
    
    context "unathenticated student" do
      it "returns unathorized access" do
        get api_v1_students_path
        expect(response).to be_unauthorized
      end
    end
  end

  describe "POST /students"  do
    it "registers new student" do
      student_attributes = attributes_for(:student)
      expect {
        post api_v1_students_path, params: { student: student_attributes }
      }.to change(Student, :count).by(1)
    end

    it "returns 401 on validation" do
      invalid_student_attributes = attributes_for(:student, email: "")
      post api_v1_students_path, params: { student: invalid_student_attributes }
      
      expect(response).to have_http_status(422)
    end
  end

  describe "PUT /students/:id" do
    let(:edited_student_info) { attributes_for(:student, first_name: "Edi") }

    context "authenticated student" do
      before(:each) do
        @auth_token = login(student)
      end

      it "updates student" do
        put api_v1_student_path(student), headers: { 'Authorization' => @auth_token }, params: {student: edited_student_info}
        student.reload

        expect(student.first_name).to eq "Edi"
      end
    end
    
    context "unathenticated student" do
      it "does not update student info" do
        put api_v1_student_path(student), params: {student: edited_student_info}
        student.reload

        expect(student.first_name).to_not eq "Edi"
      end

      it "returns :unprocessable_entity status" do
        put api_v1_student_path(student), params: {student: edited_student_info}
        
        expect(response).to be_unauthorized
      end
    end
  end

  describe "DELETE /students/:id" do
    context "authenticated student" do
      before(:each) do
        @auth_token = login(student)
      end

      it "destroys students account" do
        expect{
          delete api_v1_student_path(student), headers: { 'Authorization' => @auth_token }
        }.to change(Student, :count).by(-1)
      end

      it "does not allow other student to delete account" do
        other_student = create(:student, email: "otheruser@test.com")

        expect{
          delete api_v1_student_path(other_student), headers: { 'Authorization' => @auth_token }
        }.to change(Student, :count).by(0)
      end
    end
    
    context "unathenticated student" do
      it "does not destroys students account" do
        student = create(:student)

        expect{
          delete api_v1_student_path(student)
        }.to change(Student, :count).by(0)
      end

      it "returns :unprocessable_entity status" do
        delete api_v1_student_path(student)
        expect(response).to be_unauthorized
      end
    end
  end
end
