class MetricsController < ApplicationController
  def index
    registry = Prometheus::Client.registry

    # Format metrics in Prometheus text format
    metrics_text = format_metrics(registry)

    render plain: metrics_text, content_type: 'text/plain'
  end

  private

  def format_metrics(registry)
    output = []

    registry.metrics.each do |metric|
      case metric
      when Prometheus::Client::Counter
        output << format_counter(metric)
      when Prometheus::Client::Histogram
        output << format_histogram(metric)
      when Prometheus::Client::Gauge
        output << format_gauge(metric)
      end
    end

    output.join("\n")
  end

  def format_counter(metric)
    lines = ["# HELP #{metric.name} #{metric.docstring}", "# TYPE #{metric.name} counter"]
    metric.values.each do |labels, value|
      label_string = format_labels(labels)
      lines << "#{metric.name}#{label_string} #{value}"
    end
    lines.join("\n")
  end

  def format_histogram(metric)
    lines = ["# HELP #{metric.name} #{metric.docstring}", "# TYPE #{metric.name} histogram"]
    metric.values.each do |labels, buckets|
      label_string = format_labels(labels)
      buckets.each do |bucket, count|
        bucket_label_string = format_labels(labels.merge(le: bucket == Float::INFINITY ? '+Inf' : bucket))
        lines << "#{metric.name}_bucket#{bucket_label_string} #{count}"
      end
      lines << "#{metric.name}_count#{label_string} #{buckets.values.sum}"
      lines << "#{metric.name}_sum#{label_string} #{metric.get(labels: labels)}"
    end
    lines.join("\n")
  end

  def format_gauge(metric)
    lines = ["# HELP #{metric.name} #{metric.docstring}", "# TYPE #{metric.name} gauge"]
    metric.values.each do |labels, value|
      label_string = format_labels(labels)
      lines << "#{metric.name}#{label_string} #{value}"
    end
    lines.join("\n")
  end

  def format_labels(labels)
    return '' if labels.empty?
    "{#{labels.map { |k, v| "#{k}=\"#{v}\"" }.join(',')}}"
  end
end

