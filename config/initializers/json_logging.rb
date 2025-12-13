# Configure JSON logging for structured logs
if Rails.env.development? || Rails.env.production?
  class Logger
    def format_message(severity, timestamp, _progname, msg)
      if msg.is_a?(String) && msg.start_with?('{')
        # Already JSON formatted, return as is
        "#{msg}\n"
      else
        # Format as JSON
        log_entry = {
          timestamp: timestamp.iso8601,
          level: severity,
          message: msg,
          pid: Process.pid
        }
        "#{log_entry.to_json}\n"
      end
    end
  end
end
