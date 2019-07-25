require 'rails_helper'

RSpec.describe Course, type: :model do
  it "has a valid factory" do
    expect(build(:course)).to be_valid
  end

  let(:course) { create(:course) }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:title).is_at_least(4).is_at_most(60) }
    it { is_expected.to validate_length_of(:description).is_at_least(20) }
  end
end
