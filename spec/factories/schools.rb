FactoryBot.define do
  factory :school do
    name "ROR Academy"

    factory :school_user do
      after(:create) do |school|
        create(:user, account: school) 
      end
    end
  end
end
