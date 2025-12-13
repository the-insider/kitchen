require 'rails_helper'

RSpec.describe JsonLogger do
  let(:app) { ->(_env) { [200, {}, ['OK']] } }
  let(:middleware) { described_class.new(app) }
  let(:env) { Rack::MockRequest.env_for('/api/restaurants', method: 'GET') }

  before do
    allow(Rails.logger).to receive(:info)
  end

  it 'calls the app' do
    status, _, body = middleware.call(env)

    expect(status).to eq(200)
    expect(body).to eq(['OK'])
  end

  it 'logs request information in JSON format' do
    middleware.call(env)

    expect(Rails.logger).to have_received(:info) do |arg|
      log_data = JSON.parse(arg)
      expect(log_data).to include(
        'method' => 'GET',
        'path' => '/api/restaurants',
        'status' => 200
      )
      expect(log_data).to have_key('timestamp')
      expect(log_data).to have_key('duration_ms')
      expect(log_data).to have_key('ip')
      expect(log_data).to have_key('user_agent')
    end
  end

  it 'calculates request duration' do
    allow(Time.zone).to receive(:now).and_return(
      Time.zone.parse('2024-01-01 10:00:00'),
      Time.zone.parse('2024-01-01 10:00:01')
    )

    middleware.call(env)

    expect(Rails.logger).to have_received(:info) do |arg|
      log_data = JSON.parse(arg)
      expect(log_data['duration_ms']).to be_within(10).of(1000.0)
    end
  end
end
