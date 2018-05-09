FactoryBot.define do
  factory :visit do
    name { Faker::Lorem.word }
    user_id { Faker::Number.number(4) }
  end
end
