FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Stamos" }
    sequence(:email) { |n| "ScottFree#{n}@example.com" }
    password { "bigbarda" }
  end
end
