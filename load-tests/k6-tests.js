import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');
const requestDuration = new Trend('request_duration');

export const options = {
  stages: [
    { duration: '30s', target: 10 },  // Ramp up to 10 users
    { duration: '1m', target: 10 },  // Stay at 10 users
    { duration: '30s', target: 0 },  // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 500ms
    errors: ['rate<0.1'], // Error rate should be less than 10%
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';

// Test data - these will be created/used during tests
let restaurantId = null;
let menuId = null;

export default function () {
  // Test GET /api/restaurants
  const listRes = http.get(`${BASE_URL}/api/restaurants`);
  const listSuccess = check(listRes, {
    'GET /api/restaurants status is 200': (r) => r.status === 200,
    'GET /api/restaurants response time < 500ms': (r) => r.timings.duration < 500,
  });
  errorRate.add(!listSuccess);
  requestDuration.add(listRes.timings.duration);

  sleep(1);

  // Test POST /api/restaurants
  const createPayload = JSON.stringify({
    restaurant: {
      name: `Test Restaurant ${__VU}-${__ITER}`,
      location: 'Test City',
    },
  });
  const createRes = http.post(`${BASE_URL}/api/restaurants`, createPayload, {
    headers: { 'Content-Type': 'application/json' },
  });
  const createSuccess = check(createRes, {
    'POST /api/restaurants status is 201': (r) => r.status === 201,
    'POST /api/restaurants response time < 500ms': (r) => r.timings.duration < 500,
  });
  errorRate.add(!createSuccess);
  requestDuration.add(createRes.timings.duration);

  if (createRes.status === 201) {
    const restaurant = JSON.parse(createRes.body);
    restaurantId = restaurant.id;
  }

  sleep(1);

  if (restaurantId) {
    // Test GET /api/restaurants/:id
    const getRes = http.get(`${BASE_URL}/api/restaurants/${restaurantId}`);
    const getSuccess = check(getRes, {
      'GET /api/restaurants/:id status is 200': (r) => r.status === 200,
      'GET /api/restaurants/:id response time < 500ms': (r) => r.timings.duration < 500,
    });
    errorRate.add(!getSuccess);
    requestDuration.add(getRes.timings.duration);

    sleep(1);

    // Test POST /api/restaurants/:restaurant_id/menus
    const menuPayload = JSON.stringify({
      menu: {
        name: `Test Menu ${__VU}-${__ITER}`,
        description: 'Test description',
        price: 15.99,
        category: 'Main Course',
        dietary_type: 'veg',
      },
    });
    const menuCreateRes = http.post(
      `${BASE_URL}/api/restaurants/${restaurantId}/menus`,
      menuPayload,
      {
        headers: { 'Content-Type': 'application/json' },
      }
    );
    const menuCreateSuccess = check(menuCreateRes, {
      'POST /api/restaurants/:id/menus status is 201': (r) => r.status === 201,
      'POST /api/restaurants/:id/menus response time < 500ms': (r) => r.timings.duration < 500,
    });
    errorRate.add(!menuCreateSuccess);
    requestDuration.add(menuCreateRes.timings.duration);

    if (menuCreateRes.status === 201) {
      const menu = JSON.parse(menuCreateRes.body);
      menuId = menu.id;
    }

    sleep(1);

    // Test GET /api/restaurants/:restaurant_id/menus
    const menusListRes = http.get(`${BASE_URL}/api/restaurants/${restaurantId}/menus`);
    const menusListSuccess = check(menusListRes, {
      'GET /api/restaurants/:id/menus status is 200': (r) => r.status === 200,
      'GET /api/restaurants/:id/menus response time < 500ms': (r) => r.timings.duration < 500,
    });
    errorRate.add(!menusListSuccess);
    requestDuration.add(menusListRes.timings.duration);

    sleep(1);

    if (menuId) {
      // Test GET /api/restaurants/:restaurant_id/menus/:id
      const menuGetRes = http.get(
        `${BASE_URL}/api/restaurants/${restaurantId}/menus/${menuId}`
      );
      const menuGetSuccess = check(menuGetRes, {
        'GET /api/restaurants/:id/menus/:id status is 200': (r) => r.status === 200,
        'GET /api/restaurants/:id/menus/:id response time < 500ms': (r) => r.timings.duration < 500,
      });
      errorRate.add(!menuGetSuccess);
      requestDuration.add(menuGetRes.timings.duration);
    }
  }

  sleep(1);
}

export function handleSummary(data) {
  // Extract metrics
  const metrics = {};

  if (data.metrics && data.metrics.http_req_duration) {
    const durations = data.metrics.http_req_duration.values;
    metrics['http_req_duration'] = {
      avg: durations.avg || 0,
      min: durations.min || 0,
      max: durations.max || 0,
      p50: durations.med || 0,
      p95: durations['p(95)'] || 0,
      p99: durations['p(99)'] || 0,
    };
  }

  if (data.metrics && data.metrics.http_reqs) {
    metrics['http_reqs'] = {
      total: data.metrics.http_reqs.values.count || 0,
      rate: data.metrics.http_reqs.values.rate || 0,
    };
  }

  if (data.metrics && data.metrics.errors) {
    metrics['errors'] = {
      rate: data.metrics.errors.values.rate || 0,
      passes: data.metrics.errors.values.passes || 0,
      fails: data.metrics.errors.values.fails || 0,
    };
  }

  const summary = {
    timestamp: new Date().toISOString(),
    metrics: metrics,
  };

  return {
    'stdout': JSON.stringify(summary, null, 2),
    'load-test-results.json': JSON.stringify(summary, null, 2),
  };
}

