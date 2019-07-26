FactoryBot.define do
  factory :invalid_auth_token do
    token "HMAC_SHA1_generated_token"
    expiry 24.hours.from_now
  end
end
