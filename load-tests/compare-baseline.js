#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Configuration
const DEVIATION_THRESHOLD = 0.2; // 20% deviation allowed
const BASELINE_FILE = path.join(__dirname, 'baseline.json');
const RESULTS_FILE = process.argv[2] || path.join(__dirname, 'load-test-results.json');

function loadJSON(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const parsed = JSON.parse(content);

    // Handle k6 JSON output format - it might be wrapped
    if (parsed.metrics) {
      return parsed;
    }

    // If it's the raw k6 output, extract metrics
    if (parsed.root_group && parsed.metrics) {
      return parsed;
    }

    return parsed;
  } catch (error) {
    console.error(`Error loading ${filePath}:`, error.message);
    return null;
  }
}

function compareMetrics(baseline, current) {
  const improvements = [];
  const regressions = [];

  // Compare http_req_duration p95 (primary metric)
  if (baseline.metrics?.http_req_duration?.p95 && current.metrics?.http_req_duration?.p95) {
    const baselineP95 = baseline.metrics.http_req_duration.p95;
    const currentP95 = current.metrics.http_req_duration.p95;

    // Avoid division by zero
    if (baselineP95 > 0) {
      const deviation = (currentP95 - baselineP95) / baselineP95;

      if (Math.abs(deviation) > DEVIATION_THRESHOLD) {
        if (deviation > 0) {
          regressions.push({
            metric: 'p95_latency',
            baseline: baselineP95,
            current: currentP95,
            deviation: `${(deviation * 100).toFixed(2)}%`,
            status: 'REGRESSION',
          });
        } else {
          improvements.push({
            metric: 'p95_latency',
            baseline: baselineP95,
            current: currentP95,
            deviation: `${(deviation * 100).toFixed(2)}%`,
            status: 'IMPROVEMENT',
          });
        }
      }
    }
  }

  // Compare average latency
  if (baseline.metrics?.http_req_duration?.avg && current.metrics?.http_req_duration?.avg) {
    const baselineAvg = baseline.metrics.http_req_duration.avg;
    const currentAvg = current.metrics.http_req_duration.avg;

    if (baselineAvg > 0) {
      const deviation = (currentAvg - baselineAvg) / baselineAvg;

      if (Math.abs(deviation) > DEVIATION_THRESHOLD) {
        if (deviation > 0) {
          regressions.push({
            metric: 'avg_latency',
            baseline: baselineAvg,
            current: currentAvg,
            deviation: `${(deviation * 100).toFixed(2)}%`,
            status: 'REGRESSION',
          });
        } else {
          improvements.push({
            metric: 'avg_latency',
            baseline: baselineAvg,
            current: currentAvg,
            deviation: `${(deviation * 100).toFixed(2)}%`,
            status: 'IMPROVEMENT',
          });
        }
      }
    }
  }

  // Compare error rates (absolute difference, not percentage)
  if (baseline.metrics?.errors?.rate !== undefined && current.metrics?.errors?.rate !== undefined) {
    const baselineErrorRate = baseline.metrics.errors.rate;
    const currentErrorRate = current.metrics.errors.rate;
    const deviation = currentErrorRate - baselineErrorRate;

    // Error rate threshold: 5% absolute increase
    if (deviation > 0.05) {
      regressions.push({
        metric: 'error_rate',
        baseline: baselineErrorRate,
        current: currentErrorRate,
        deviation: `${(deviation * 100).toFixed(2)}%`,
        status: 'REGRESSION',
      });
    } else if (deviation < -0.05) {
      improvements.push({
        metric: 'error_rate',
        baseline: baselineErrorRate,
        current: currentErrorRate,
        deviation: `${(deviation * 100).toFixed(2)}%`,
        status: 'IMPROVEMENT',
      });
    }
  }

  return { regressions, improvements };
}

function generateReport(comparison) {
  let report = '# Load Test Results\n\n';

  if (comparison.regressions.length > 0) {
    report += '## ⚠️ Performance Regressions Detected\n\n';
    report += '| Metric | Baseline | Current | Deviation | Status |\n';
    report += '|--------|----------|---------|-----------|--------|\n';
    comparison.regressions.forEach((r) => {
      report += `| ${r.metric} | ${r.baseline.toFixed(2)}ms | ${r.current.toFixed(2)}ms | ${r.deviation} | ${r.status} |\n`;
    });
    report += '\n';
  }

  if (comparison.improvements.length > 0) {
    report += '## ✅ Performance Improvements\n\n';
    report += '| Metric | Baseline | Current | Deviation | Status |\n';
    report += '|--------|----------|---------|-----------|--------|\n';
    comparison.improvements.forEach((i) => {
      report += `| ${i.metric} | ${i.baseline.toFixed(2)}ms | ${i.current.toFixed(2)}ms | ${i.deviation} | ${i.status} |\n`;
    });
    report += '\n';
  }

  if (comparison.regressions.length === 0 && comparison.improvements.length === 0) {
    report += '## ✅ No Significant Changes\n\n';
    report += 'Performance metrics are within acceptable deviation thresholds.\n\n';
  }

  return report;
}

// Main execution
const baseline = loadJSON(BASELINE_FILE);
const current = loadJSON(RESULTS_FILE);

if (!baseline) {
  console.error('Baseline file not found. Creating initial baseline...');
  if (current) {
    fs.writeFileSync(BASELINE_FILE, JSON.stringify(current, null, 2));
    console.log('Baseline created successfully.');
    process.exit(0);
  } else {
    console.error('Cannot create baseline: no results file found.');
    process.exit(1);
  }
}

if (!current) {
  console.error('Results file not found.');
  process.exit(1);
}

const comparison = compareMetrics(baseline, current);
const report = generateReport(comparison);

// Output report
console.log(report);

// Write report to file
const reportFile = path.join(__dirname, 'load-test-report.md');
fs.writeFileSync(reportFile, report);

// Exit with error code if there are regressions
if (comparison.regressions.length > 0) {
  console.error('\n❌ Load test failed: Performance regressions detected!');
  process.exit(1);
} else {
  console.log('\n✅ Load test passed: No significant regressions detected.');
  process.exit(0);
}

