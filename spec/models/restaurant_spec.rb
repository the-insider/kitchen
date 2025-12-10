require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
  end

  describe 'attributes' do
    it 'has a name attribute' do
      restaurant = Restaurant.new(name: 'Test Restaurant')
      expect(restaurant.name).to eq('Test Restaurant')
    end

    it 'has a location attribute' do
      restaurant = Restaurant.new(location: 'New York')
      expect(restaurant.location).to eq('New York')
    end
  end

  describe 'database' do
    it 'uses UUID as primary key' do
      restaurant = create(:restaurant)
      expect(restaurant.id).to be_a(String)
      expect(restaurant.id.length).to eq(36) # UUID v4 format
      expect(restaurant.id).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:restaurant)).to be_valid
    end
  end
end

