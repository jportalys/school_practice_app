require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user, account: create(:student))).to be_valid
  end

  let(:user) { create(:user) }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to_not allow_value("johntest").for(:email) }
    it { is_expected.to_not allow_value("johntest.com").for(:email) }
    it { is_expected.to allow_value("john@test").for(:email) }
    it { is_expected.to allow_value("john@test.com").for(:email) }
    it { is_expected.to validate_confirmation_of(:password) }
  end

  describe "public instance methods", current: true do
    context "responds to its methods" do
      it { is_expected.to respond_to(:account_type_is_student) }
      it { is_expected.to respond_to(:account_type_is_school) }
    end

    context "executes methods correctly" do
      it "confirms if the user account is student" do
        student = create(:student_user)

        expect(student.user.account_type_is_student).to be true
        expect(student.user.account_type_is_school).to be false
      end

      it "confirms if the user account is student" do
        school = create(:school_user)

        expect(school.user.account_type_is_school).to be true
        expect(school.user.account_type_is_student).to be false
      end
    end
  end
end
