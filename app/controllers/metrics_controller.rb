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
    metric.values.each_pair do |labels, value|
      label_string = format_labels(labels)
      lines << "#{metric.name}#{label_string} #{value}"
    end
    lines.join("\n")
  end

  def format_histogram(metric)
    lines = ["# HELP #{metric.name} #{metric.docstring}", "# TYPE #{metric.name} histogram"]
    metric.values.each_pair do |labels, buckets|
      lines.concat(format_histogram_buckets(metric.name, labels, buckets))
      lines.concat(format_histogram_summary(metric, metric.name, labels, buckets))
    end
    lines.join("\n")
  end

  def format_histogram_buckets(metric_name, labels, buckets)
    buckets.map do |bucket, count|
      bucket_label = format_labels(labels.merge(le: bucket == Float::INFINITY ? '+Inf' : bucket))
      "#{metric_name}_bucket#{bucket_label} #{count}"
    end
  end

  def format_histogram_summary(metric, metric_name, labels, buckets)
    label_string = format_labels(labels)
    [
      "#{metric_name}_count#{label_string} #{buckets.values.sum}",
      "#{metric_name}_sum#{label_string} #{metric.get(labels: labels)}"
    ]
  end

  def format_gauge(metric)
    lines = ["# HELP #{metric.name} #{metric.docstring}", "# TYPE #{metric.name} gauge"]
    metric.values.each_pair do |labels, value|
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
