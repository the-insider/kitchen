# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Rails.logger.debug 'Creating sample restaurants and menus...'

# Clear existing data
Restaurant.destroy_all

# Restaurant 1: Italian Restaurant
restaurant1 = Restaurant.create!(
  name: "Mario's Italian Bistro",
  location: 'New York, NY'
)

restaurant1.menus.create!([
                            {
                              name: 'Margherita Pizza',
                              description: 'Classic pizza with fresh mozzarella, tomato sauce, and basil',
                              price: 18.99,
                              category: 'Main Course',
                              dietary_type: 'veg'
                            },
                            {
                              name: 'Spaghetti Carbonara',
                              description: 'Creamy pasta with bacon, eggs, and parmesan cheese',
                              price: 22.99,
                              category: 'Main Course',
                              dietary_type: 'non_veg'
                            },
                            {
                              name: 'Caesar Salad',
                              description: 'Fresh romaine lettuce with caesar dressing and croutons',
                              price: 12.99,
                              category: 'Appetizer',
                              dietary_type: 'veg'
                            },
                            {
                              name: 'Tiramisu',
                              description: 'Classic Italian dessert with coffee and mascarpone',
                              price: 9.99,
                              category: 'Dessert',
                              dietary_type: 'veg'
                            }
                          ])

# Restaurant 2: Indian Restaurant
restaurant2 = Restaurant.create!(
  name: 'Spice Garden',
  location: 'San Francisco, CA'
)

restaurant2.menus.create!([
                            {
                              name: 'Butter Chicken',
                              description: 'Creamy tomato-based curry with tender chicken pieces',
                              price: 19.99,
                              category: 'Main Course',
                              dietary_type: 'non_veg'
                            },
                            {
                              name: 'Palak Paneer',
                              description: 'Spinach curry with fresh cottage cheese',
                              price: 16.99,
                              category: 'Main Course',
                              dietary_type: 'veg'
                            },
                            {
                              name: 'Vegan Biryani',
                              description: 'Fragrant basmati rice with mixed vegetables and spices',
                              price: 17.99,
                              category: 'Main Course',
                              dietary_type: 'vegan'
                            },
                            {
                              name: 'Samosas',
                              description: 'Crispy pastries filled with spiced potatoes and peas',
                              price: 6.99,
                              category: 'Appetizer',
                              dietary_type: 'veg'
                            },
                            {
                              name: 'Gulab Jamun',
                              description: 'Sweet milk dumplings in rose-flavored syrup',
                              price: 7.99,
                              category: 'Dessert',
                              dietary_type: 'veg'
                            }
                          ])

# Restaurant 3: Japanese Restaurant
restaurant3 = Restaurant.create!(
  name: 'Sakura Sushi',
  location: 'Los Angeles, CA'
)

restaurant3.menus.create!([
                            {
                              name: 'Salmon Sashimi',
                              description: 'Fresh raw salmon slices',
                              price: 24.99,
                              category: 'Main Course',
                              dietary_type: 'non_veg'
                            },
                            {
                              name: 'Avocado Roll',
                              description: 'Sushi roll with fresh avocado and cucumber',
                              price: 8.99,
                              category: 'Main Course',
                              dietary_type: 'vegan'
                            },
                            {
                              name: 'Miso Soup',
                              description: 'Traditional Japanese soup with tofu and seaweed',
                              price: 5.99,
                              category: 'Appetizer',
                              dietary_type: 'vegan'
                            },
                            {
                              name: 'Edamame',
                              description: 'Steamed young soybeans with sea salt',
                              price: 6.99,
                              category: 'Appetizer',
                              dietary_type: 'vegan'
                            },
                            {
                              name: 'Green Tea Ice Cream',
                              description: 'Creamy ice cream with matcha flavor',
                              price: 7.99,
                              category: 'Dessert',
                              dietary_type: 'veg'
                            }
                          ])

# Restaurant 4: Mexican Restaurant
restaurant4 = Restaurant.create!(
  name: 'El Mariachi',
  location: 'Austin, TX'
)

restaurant4.menus.create!([
                            {
                              name: 'Chicken Tacos',
                              description: 'Three soft tacos with grilled chicken, onions, and cilantro',
                              price: 14.99,
                              category: 'Main Course',
                              dietary_type: 'non_veg'
                            },
                            {
                              name: 'Vegetarian Burrito',
                              description: 'Large flour tortilla with beans, rice, cheese, and vegetables',
                              price: 12.99,
                              category: 'Main Course',
                              dietary_type: 'veg'
                            },
                            {
                              name: 'Guacamole',
                              description: 'Fresh avocado dip with tomatoes, onions, and lime',
                              price: 8.99,
                              category: 'Appetizer',
                              dietary_type: 'vegan'
                            },
                            {
                              name: 'Churros',
                              description: 'Fried dough pastries with cinnamon sugar',
                              price: 6.99,
                              category: 'Dessert',
                              dietary_type: 'veg'
                            }
                          ])

# Restaurant 5: American Diner
restaurant5 = Restaurant.create!(
  name: 'The Classic Diner',
  location: 'Chicago, IL'
)

restaurant5.menus.create!([
                            {
                              name: 'Classic Burger',
                              description: 'Beef patty with lettuce, tomato, onion, and special sauce',
                              price: 15.99,
                              category: 'Main Course',
                              dietary_type: 'non_veg'
                            },
                            {
                              name: 'Veggie Burger',
                              description: 'Plant-based patty with all the fixings',
                              price: 13.99,
                              category: 'Main Course',
                              dietary_type: 'vegan'
                            },
                            {
                              name: 'Caesar Salad',
                              description: 'Crisp romaine with caesar dressing',
                              price: 11.99,
                              category: 'Appetizer',
                              dietary_type: 'veg'
                            },
                            {
                              name: 'Apple Pie',
                              description: 'Homemade pie with vanilla ice cream',
                              price: 8.99,
                              category: 'Dessert',
                              dietary_type: 'veg'
                            },
                            {
                              name: 'French Fries',
                              description: 'Crispy golden fries with ketchup',
                              price: 5.99,
                              category: 'Appetizer',
                              dietary_type: 'vegan'
                            }
                          ])

Rails.logger.debug { "Created #{Restaurant.count} restaurants with #{Menu.count} total menu items!" }
Rails.logger.debug "\nRestaurants:"
Restaurant.find_each do |restaurant|
  Rails.logger.debug "  - #{restaurant.name} (#{restaurant.location}) - #{restaurant.menus.count} menu items"
end
