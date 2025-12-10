require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe 'attributes' do
    it 'has a name attribute' do
      menu = Menu.new(name: 'Pizza')
      expect(menu.name).to eq('Pizza')
    end

    it 'has a description attribute' do
      menu = Menu.new(description: 'Delicious pizza')
      expect(menu.description).to eq('Delicious pizza')
    end

    it 'has a price attribute' do
      menu = Menu.new(price: 12.99)
      expect(menu.price).to eq(12.99)
    end

    it 'has a category attribute' do
      menu = Menu.new(category: 'Main Course')
      expect(menu.category).to eq('Main Course')
    end
  end

  describe 'database' do
    it 'uses UUID as primary key' do
      restaurant = create(:restaurant)
      menu = create(:menu, restaurant: restaurant)
      expect(menu.id).to be_a(String)
      expect(menu.id.length).to eq(36) # UUID v4 format
      expect(menu.id).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
    end

    it 'uses UUID for restaurant_id foreign key' do
      restaurant = create(:restaurant)
      menu = create(:menu, restaurant: restaurant)
      expect(menu.restaurant_id).to be_a(String)
      expect(menu.restaurant_id).to eq(restaurant.id)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      restaurant = create(:restaurant)
      expect(build(:menu, restaurant: restaurant)).to be_valid
    end
  end
end

