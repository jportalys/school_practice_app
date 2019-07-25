FactoryBot.define do
  factory :student do
    first_name "John"
    middle_name "Umber"
    last_name "Oliver"
    gender "male"

    factory :student_user do
      after(:create) do |student|
        create(:user, account: student)
      end
    end
  end
end
