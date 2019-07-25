require 'rails_helper'

RSpec.describe School, type: :model do
  it "has a valid factory" do
    expect(build(:school)).to be_valid
  end

  let(:school) { create(:school) }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
