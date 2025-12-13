require 'rails_helper'

RSpec.describe Menu do
  describe 'associations' do
    it { is_expected.to belong_to(:restaurant) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  end

  describe 'attributes' do
    it 'has a name attribute' do
      menu = described_class.new(name: 'Pizza')
      expect(menu.name).to eq('Pizza')
    end

    it 'has a description attribute' do
      menu = described_class.new(description: 'Delicious pizza')
      expect(menu.description).to eq('Delicious pizza')
    end

    it 'has a price attribute' do
      menu = described_class.new(price: 12.99)
      expect(menu.price).to eq(12.99)
    end

    it 'has a category attribute' do
      menu = described_class.new(category: 'Main Course')
      expect(menu.category).to eq('Main Course')
    end

    it 'has a dietary_type attribute' do
      menu = described_class.new(dietary_type: 'veg')
      expect(menu.dietary_type).to eq('veg')
    end
  end

  describe 'enum' do
    it 'defines dietary_type enum with veg, non_veg, and vegan' do
      restaurant = create(:restaurant)
      menu = create(:menu, restaurant: restaurant, dietary_type: :veg)
      expect(menu.veg?).to be true
      expect(menu.non_veg?).to be false
      expect(menu.vegan?).to be false

      menu.dietary_type = :non_veg
      expect(menu.non_veg?).to be true

      menu.dietary_type = :vegan
      expect(menu.vegan?).to be true
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
