require 'rails_helper'

RSpec.describe Student, type: :model do
  it "has a valid factory" do
    expect(build(:student)).to be_valid
  end

  let(:student) { create(:student) }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:middle_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:password) }
  end
end