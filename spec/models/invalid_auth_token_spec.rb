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

  describe "Table cleanup", current: true do
    it "deletes blacklisted token base on expiry" do
      create(:invalid_auth_token, token: "to be cleaned token_a", expiry: 1.hour.ago)
      create(:invalid_auth_token, token: "to be cleaned token_b", expiry: 2.hours.ago)
      create(:invalid_auth_token, token: "still fresh token", expiry: 1.day.from_now)

      expect{
        InvalidAuthToken.cleanup
      }.to change(InvalidAuthToken, :count).by(-2)
    end
  end
end
