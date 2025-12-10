FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    location { Faker::Address.city }
  end
end

