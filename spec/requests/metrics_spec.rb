require 'rails_helper'

RSpec.describe 'Metrics API' do
  describe 'GET /metrics' do
    it 'returns Prometheus metrics in text format' do
      get '/metrics'

      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/plain')
      expect(response.body).to include('# HELP')
      expect(response.body).to include('# TYPE')
    end

    it 'includes counter metrics when requests are made' do
      # Make a request to generate metrics
      get '/api/restaurants'

      get '/metrics'

      expect(response.body).to match(/http_requests_total/)
    end

    it 'includes histogram metrics when requests are made' do
      # Make a request to generate metrics
      get '/api/restaurants'

      get '/metrics'

      expect(response.body).to match(/http_request_duration_seconds/)
    end

    it 'returns valid Prometheus format' do
      get '/metrics'

      # Prometheus format should have HELP and TYPE lines
      lines = response.body.split("\n")
      help_lines = lines.select { |l| l.start_with?('# HELP') }
      type_lines = lines.select { |l| l.start_with?('# TYPE') }

      expect(help_lines).not_to be_empty
      expect(type_lines).not_to be_empty
    end
  end
end

