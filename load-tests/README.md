# Load Testing

This directory contains load testing scripts using k6.

## Files

- `k6-tests.js` - Main k6 load test script that tests all API endpoints
- `compare-baseline.js` - Node.js script to compare current results with baseline
- `baseline.json` - Baseline metrics (committed to repo, updated when performance improves)

## Running Load Tests Locally

### Prerequisites

Install k6:
```bash
# macOS
brew install k6

# Linux
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D9B
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install -y k6
```

### Run Tests

```bash
# Test against local server
k6 run load-tests/k6-tests.js --env BASE_URL=http://localhost:3000

# Test against deployed environment
k6 run load-tests/k6-tests.js --env BASE_URL=https://kitchen-test.fly.dev
```

### Compare with Baseline

```bash
# After running tests, compare with baseline
node load-tests/compare-baseline.js load-test-results.json
```

## Baseline Management

The baseline is stored in `baseline.json`. To update the baseline:

1. Run load tests against a known good deployment
2. Copy `load-test-results.json` to `baseline.json`
3. Commit the updated baseline

## CI/CD Integration

Load tests run automatically:
- **PR Deployments**: After preview deployment, results are posted as PR comments
- **Integration Tests**: After QA deployment, results are compared to baseline and fail if deviation > 20%

## Metrics Tracked

- **p95 Latency**: 95th percentile response time
- **Average Latency**: Mean response time
- **Error Rate**: Percentage of failed requests
- **Request Count**: Total number of requests

## Thresholds

- **Deviation Threshold**: 20% (configurable in `compare-baseline.js`)
- **Response Time Threshold**: 95% of requests should be < 500ms

