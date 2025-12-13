require 'rails_helper'

RSpec.describe 'Menus API' do
  let(:restaurant) { create(:restaurant) }

  describe 'GET /api/restaurants/:restaurant_id/menus' do
    it 'returns all menus for a restaurant' do
      create(:menu, restaurant: restaurant, name: 'Menu 1', price: 10.99)
      create(:menu, restaurant: restaurant, name: 'Menu 2', price: 15.99)

      get "/api/restaurants/#{restaurant.id}/menus"

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json.length).to eq(2)
      expect(json.first['name']).to eq('Menu 1')
      expect(json.first['price']).to eq('10.99')
    end

    it 'returns empty array when no menus exist' do
      get "/api/restaurants/#{restaurant.id}/menus"

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json).to eq([])
    end
  end

  describe 'GET /api/restaurants/:restaurant_id/menus/:id' do
    it 'returns a specific menu' do
      menu = create(:menu, restaurant: restaurant, name: 'Test Menu', price: 12.99)

      get "/api/restaurants/#{restaurant.id}/menus/#{menu.id}"

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json['id']).to eq(menu.id)
      expect(json['name']).to eq('Test Menu')
      expect(json['price']).to eq('12.99')
    end

    it 'returns 404 when menu not found' do
      get "/api/restaurants/#{restaurant.id}/menus/non-existent-id"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/restaurants/:restaurant_id/menus' do
    it 'creates a new menu' do
      menu_params = {
        menu: {
          name: 'New Menu',
          description: 'Delicious food',
          price: 20.99,
          category: 'Main Course',
          dietary_type: 'veg'
        }
      }

      expect do
        post "/api/restaurants/#{restaurant.id}/menus", params: menu_params
      end.to change(Menu, :count).by(1)

      expect(response).to have_http_status(:created)
      json = response.parsed_body
      expect(json['name']).to eq('New Menu')
      expect(json['price']).to eq('20.99')
      expect(json['dietary_type']).to eq('veg')
    end

    it 'returns errors when validation fails' do
      menu_params = {
        menu: {
          name: '',
          price: -1
        }
      }

      post "/api/restaurants/#{restaurant.id}/menus", params: menu_params

      expect(response).to have_http_status(:unprocessable_entity)
      json = response.parsed_body
      expect(json['errors']).to be_present
    end
  end

  describe 'PATCH /api/restaurants/:restaurant_id/menus/:id' do
    it 'updates a menu' do
      menu = create(:menu, restaurant: restaurant, name: 'Old Name', price: 10.99)

      menu_params = {
        menu: {
          name: 'Updated Name',
          price: 25.99
        }
      }

      patch "/api/restaurants/#{restaurant.id}/menus/#{menu.id}", params: menu_params

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json['name']).to eq('Updated Name')
      expect(json['price']).to eq('25.99')
      menu.reload
      expect(menu.name).to eq('Updated Name')
    end
  end

  describe 'DELETE /api/restaurants/:restaurant_id/menus/:id' do
    it 'deletes a menu' do
      menu = create(:menu, restaurant: restaurant)

      expect do
        delete "/api/restaurants/#{restaurant.id}/menus/#{menu.id}"
      end.to change(Menu, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
