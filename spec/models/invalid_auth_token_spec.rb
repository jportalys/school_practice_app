require 'rails_helper'

RSpec.describe InvalidAuthToken, type: :model do
  describe "Class methods" do
    it "expected to respond to crosscheck class method" do
      expect(described_class).to respond_to(:crosscheck)
    end
  end

  describe "Class methods execute correctly" do
    it "raise ActiveRecord::RecordNotFound if token is in the blacklist" do
      InvalidAuthToken.create(token: "token")
      expect{ described_class.crosscheck("token") }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
