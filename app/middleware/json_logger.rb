class JsonLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    start_time = Time.now

    status, headers, response = @app.call(env)

    duration = ((Time.now - start_time) * 1000).round(2) # in milliseconds

    log_request(request, status, duration)

    [status, headers, response]
  end

  private

  def log_request(request, status, duration)
    log_data = {
      timestamp: Time.now.iso8601,
      method: request.method,
      path: request.path,
      status: status,
      duration_ms: duration,
      ip: request.remote_ip,
      user_agent: request.user_agent
    }

    Rails.logger.info(log_data.to_json)
  end
end

