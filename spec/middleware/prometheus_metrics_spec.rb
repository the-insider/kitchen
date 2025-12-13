require 'rails_helper'

RSpec.describe PrometheusMetrics do
  let(:app) { ->(_env) { [200, {}, ['OK']] } }
  let(:middleware) { described_class.new(app) }
  let(:env) { Rack::MockRequest.env_for('/api/restaurants', method: 'GET') }

  before do
    # Clear metrics before each test
    Prometheus::Client.registry.metrics.each do |metric|
      metric.values.clear if metric.respond_to?(:values)
    end
  end

  it 'calls the app' do
    status, _, body = middleware.call(env)

    expect(status).to eq(200)
    expect(body).to eq(['OK'])
  end

  it 'increments http_requests_total counter' do
    middleware.call(env)

    counter = Prometheus::Client.registry.get(:http_requests_total)
    expect(counter).to be_present

    # Check that a metric was recorded
    values = counter.values
    expect(values).not_to be_empty
  end

  it 'records request duration in histogram' do
    middleware.call(env)

    histogram = Prometheus::Client.registry.get(:http_request_duration_seconds)
    expect(histogram).to be_present

    # Check that a metric was recorded
    values = histogram.values
    expect(values).not_to be_empty
  end

  it 'normalizes paths with IDs' do
    env_with_id = Rack::MockRequest.env_for('/api/restaurants/123', method: 'GET')
    middleware.call(env_with_id)

    counter = Prometheus::Client.registry.get(:http_requests_total)
    values = counter.values

    # Check that path was normalized
    path_labels = values.keys.pluck(:path)
    expect(path_labels).to include('/api/restaurants/:id')
  end

  it 'normalizes nested paths with IDs' do
    env_with_nested = Rack::MockRequest.env_for('/api/restaurants/123/menus/456', method: 'GET')
    middleware.call(env_with_nested)

    counter = Prometheus::Client.registry.get(:http_requests_total)
    values = counter.values

    # Check that path was normalized
    path_labels = values.keys.pluck(:path)
    expect(path_labels).to include('/api/restaurants/:id/menus/:id')
  end

  it 'normalizes menu collection paths' do
    env_with_collection = Rack::MockRequest.env_for('/api/restaurants/123/menus', method: 'GET')
    middleware.call(env_with_collection)

    counter = Prometheus::Client.registry.get(:http_requests_total)
    values = counter.values

    # Check that path was normalized
    path_labels = values.keys.pluck(:path)
    expect(path_labels).to include('/api/restaurants/:id/menus')
  end

  it 'records correct labels for metrics' do
    # Use a unique path to avoid conflicts with other tests
    unique_path = '/api/test-unique-path'
    env_post = Rack::MockRequest.env_for(unique_path, method: 'POST')
    middleware.call(env_post)

    counter = Prometheus::Client.registry.get(:http_requests_total)
    values = counter.values

    # Find the POST request metric for this specific unique path
    post_metric = values.find { |labels, _value| labels[:method] == 'POST' && labels[:path] == unique_path }
    expect(post_metric).to be_present
    expect(post_metric[0][:method]).to eq('POST')
    expect(post_metric[0][:status]).to eq('200')
    expect(post_metric[0][:path]).to eq(unique_path)
  end
end
