require 'rails_helper'

RSpec.describe 'Version API' do
  describe 'GET /version' do
    it 'returns version information' do
      get '/version'

      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')

      json_response = response.parsed_body
      expect(json_response).to have_key('rails_env')
      expect(json_response).to have_key('build_version')
      expect(json_response['rails_env']).to eq(Rails.env)
    end

    context 'when BUILD_VERSION is set' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('BUILD_VERSION').and_return('v1.2.3-20241214120000')
      end

      it 'returns the BUILD_VERSION' do
        get '/version'

        json_response = response.parsed_body
        expect(json_response['build_version']).to eq('v1.2.3-20241214120000')
      end
    end

    context 'when BUILD_VERSION is not set' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('BUILD_VERSION').and_return(nil)
      end

      it 'returns unknown for build_version' do
        get '/version'

        json_response = response.parsed_body
        expect(json_response['build_version']).to eq('unknown')
      end
    end
  end
end
