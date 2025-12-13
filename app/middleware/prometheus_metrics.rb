require 'prometheus/client'

class PrometheusMetrics
  METRICS = {
    http_requests_total: Prometheus::Client.registry.counter(
      :http_requests_total,
      docstring: 'Total number of HTTP requests',
      labels: %i[method path status]
    ),
    http_request_duration_seconds: Prometheus::Client.registry.histogram(
      :http_request_duration_seconds,
      docstring: 'HTTP request duration in seconds',
      labels: %i[method path status],
      buckets: [0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]
    )
  }.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    start_time = Time.zone.now

    status, headers, response = @app.call(env)

    duration = Time.zone.now - start_time
    path = normalize_path(request.path)

    # Record metrics
    labels = {
      method: request.method,
      path: path,
      status: status.to_s
    }

    METRICS[:http_requests_total].increment(labels: labels)
    METRICS[:http_request_duration_seconds].observe(duration, labels: labels)

    [status, headers, response]
  end

  private

  def normalize_path(path)
    # Normalize paths to avoid high cardinality (e.g., /api/restaurants/123 -> /api/restaurants/:id)
    path.gsub(%r{/api/restaurants/[^/]+}, '/api/restaurants/:id')
        .gsub(%r{/api/restaurants/[^/]+/menus/[^/]+}, '/api/restaurants/:id/menus/:id')
        .gsub(%r{/api/restaurants/[^/]+/menus}, '/api/restaurants/:id/menus')
  end
end
