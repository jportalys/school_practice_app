require 'rails_helper'

RSpec.describe School, type: :model do
  it "has a valid factory" do
    expect(build(:school)).to be_valid
  end

  let(:school) { create(:school) }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    # it { is_expected.to validate_presence_of(:email) }
    # it { is_expected.to validate_presence_of(:password) }

    # it { is_expected.to_not allow_value("johntest").for(:email) }
    # it { is_expected.to_not allow_value("johntest.com").for(:email) }
    # it { is_expected.to allow_value("john@test").for(:email) }
    # it { is_expected.to allow_value("john@test.com").for(:email) }

    # it { is_expected.to validate_confirmation_of(:password) }
  end
end
