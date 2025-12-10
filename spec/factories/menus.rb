FactoryBot.define do
  factory :menu do
    association :restaurant
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Commerce.price(range: 5.0..50.0) }
    category { ['Appetizer', 'Main Course', 'Dessert', 'Beverage'].sample }
    dietary_type { [:veg, :non_veg, :vegan].sample }
  end
end

