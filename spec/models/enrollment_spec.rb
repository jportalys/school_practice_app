require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe "public instance methods" do
    context "it responds to its methods" do
      it { is_expected.to respond_to(:unenroll) }
    end

    context "executes methods correctly" do
      it "should call destroy with student is equal to enrollment student" do
        student = create(:student)
        enrollment = create(:enrollment, student: student, course: create(:course))

        expect(enrollment).to receive(:destroy)
        enrollment.unenroll(student)
      end

      it "should not call destroy when student is not the student in the enrollment" do
        student = create(:student)
        enrollment = create(:enrollment, student: create(:student), course: create(:course))

        expect(enrollment).to_not receive(:destroy)
        enrollment.unenroll(student)
      end
    end
  end
end
