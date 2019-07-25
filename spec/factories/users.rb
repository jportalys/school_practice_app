FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "johnoliver_" + n.to_s + "@test.com" }
    password "password"
    password_confirmation "password"
  end
end
