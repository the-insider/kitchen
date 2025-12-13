require 'rails_helper'

RSpec.describe 'Restaurants API' do
  describe 'GET /api/restaurants' do
    it 'returns all restaurants' do
      create(:restaurant, name: 'Restaurant 1', location: 'NYC')
      create(:restaurant, name: 'Restaurant 2', location: 'LA')

      get '/api/restaurants'

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json.length).to eq(2)
      expect(json.first['name']).to eq('Restaurant 1')
      expect(json.first['location']).to eq('NYC')
    end

    it 'returns empty array when no restaurants exist' do
      get '/api/restaurants'

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json).to eq([])
    end
  end

  describe 'GET /api/restaurants/:id' do
    it 'returns a specific restaurant' do
      restaurant = create(:restaurant, name: 'Test Restaurant', location: 'Test City')

      get "/api/restaurants/#{restaurant.id}"

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json['id']).to eq(restaurant.id)
      expect(json['name']).to eq('Test Restaurant')
      expect(json['location']).to eq('Test City')
    end

    it 'returns 404 when restaurant not found' do
      get '/api/restaurants/non-existent-id'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/restaurants' do
    it 'creates a new restaurant' do
      restaurant_params = {
        restaurant: {
          name: 'New Restaurant',
          location: 'New City'
        }
      }

      expect do
        post '/api/restaurants', params: restaurant_params
      end.to change(Restaurant, :count).by(1)

      expect(response).to have_http_status(:created)
      json = response.parsed_body
      expect(json['name']).to eq('New Restaurant')
      expect(json['location']).to eq('New City')
    end

    it 'returns errors when validation fails' do
      restaurant_params = {
        restaurant: {
          name: '',
          location: ''
        }
      }

      post '/api/restaurants', params: restaurant_params

      expect(response).to have_http_status(:unprocessable_entity)
      json = response.parsed_body
      expect(json['errors']).to be_present
    end
  end

  describe 'PATCH /api/restaurants/:id' do
    it 'updates a restaurant' do
      restaurant = create(:restaurant, name: 'Old Name', location: 'Old Location')

      restaurant_params = {
        restaurant: {
          name: 'Updated Name',
          location: 'Updated Location'
        }
      }

      patch "/api/restaurants/#{restaurant.id}", params: restaurant_params

      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json['name']).to eq('Updated Name')
      expect(json['location']).to eq('Updated Location')
      restaurant.reload
      expect(restaurant.name).to eq('Updated Name')
    end

    it 'returns 404 when restaurant not found' do
      patch '/api/restaurants/non-existent-id', params: { restaurant: { name: 'Test' } }

      expect(response).to have_http_status(:not_found)
      json = response.parsed_body
      expect(json['error']).to eq('Restaurant not found')
    end

    it 'returns errors when validation fails' do
      restaurant = create(:restaurant, name: 'Test Restaurant', location: 'Test City')

      restaurant_params = {
        restaurant: {
          name: '',
          location: ''
        }
      }

      patch "/api/restaurants/#{restaurant.id}", params: restaurant_params

      expect(response).to have_http_status(:unprocessable_entity)
      json = response.parsed_body
      expect(json['errors']).to be_present
    end
  end

  describe 'DELETE /api/restaurants/:id' do
    it 'deletes a restaurant' do
      restaurant = create(:restaurant)

      expect do
        delete "/api/restaurants/#{restaurant.id}"
      end.to change(Restaurant, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 when restaurant not found' do
      delete '/api/restaurants/non-existent-id'

      expect(response).to have_http_status(:not_found)
    end
  end
end
