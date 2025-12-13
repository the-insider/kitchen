# Load and configure custom middleware
require Rails.root.join('app/middleware/json_logger')
require Rails.root.join('app/middleware/prometheus_metrics')

Rails.application.config.middleware.use JsonLogger
Rails.application.config.middleware.use PrometheusMetrics
