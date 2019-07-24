FactoryBot.define do
  factory :student do
    email "johnoliver@test.com"
    first_name "John"
    middle_name "Umber"
    last_name "Oliver"
    gender "male"
    password "password"
    password_confirmation "password"
  end
end
