FactoryBot.define do
  factory :invalid_token do
    token "HMAC_SHA1_generated_token"
  end
end
