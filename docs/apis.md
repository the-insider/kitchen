# Kitchen API Documentation

## Base URL

```
http://localhost:3000
```

All API endpoints are prefixed with `/api` except for the metrics endpoint.
All requests and responses use `application/json`.

## Authentication

Currently, the API does not require authentication. This may change in future versions.

---

## Restaurants API

### List All Restaurants

Get a list of all restaurants.

**Endpoint:** `GET /api/restaurants`

**Response:** `200 OK`

```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Mario's Italian Bistro",
    "location": "New York, NY",
    "created_at": "2025-12-10T12:00:00.000Z",
    "updated_at": "2025-12-10T12:00:00.000Z"
  },
  {
    "id": "660e8400-e29b-41d4-a716-446655440001",
    "name": "Spice Garden",
    "location": "San Francisco, CA",
    "created_at": "2025-12-10T12:00:00.000Z",
    "updated_at": "2025-12-10T12:00:00.000Z"
  }
]
```

### Get a Restaurant

Get details of a specific restaurant.

**Endpoint:** `GET /api/restaurants/:id`

**Parameters:**
- `id` (UUID) - Restaurant identifier

**Response:** `200 OK`

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Mario's Italian Bistro",
  "location": "New York, NY",
  "created_at": "2025-12-10T12:00:00.000Z",
  "updated_at": "2025-12-10T12:00:00.000Z"
}
```

**Error Response:** `404 Not Found`

```json
{
  "error": "Restaurant not found"
}
```

### Create a Restaurant

Create a new restaurant.

**Endpoint:** `POST /api/restaurants`

**Request Body:**

```json
{
  "restaurant": {
    "name": "New Restaurant",
    "location": "New City"
  }
}
```

**Response:** `201 Created`

```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "name": "New Restaurant",
  "location": "New City",
  "created_at": "2025-12-10T12:00:00.000Z",
  "updated_at": "2025-12-10T12:00:00.000Z"
}
```

**Error Response:** `422 Unprocessable Entity`

```json
{
  "errors": ["Name can't be blank", "Location can't be blank"]
}
```

### Update a Restaurant

Update an existing restaurant.

**Endpoint:** `PATCH /api/restaurants/:id` or `PUT /api/restaurants/:id`

**Parameters:**
- `id` (UUID) - Restaurant identifier

**Request Body:**

```json
{
  "restaurant": {
    "name": "Updated Restaurant Name",
    "location": "Updated Location"
  }
}
```

**Response:** `200 OK`

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Updated Restaurant Name",
  "location": "Updated Location",
  "created_at": "2025-12-10T12:00:00.000Z",
  "updated_at": "2025-12-10T12:05:00.000Z"
}
```

**Error Responses:**
- `404 Not Found` - Restaurant not found
- `422 Unprocessable Entity` - Validation errors

### Delete a Restaurant

Delete a restaurant and all its associated menus.

**Endpoint:** `DELETE /api/restaurants/:id`

**Parameters:**
- `id` (UUID) - Restaurant identifier

**Response:** `204 No Content`

**Error Response:** `404 Not Found`

```json
{
  "error": "Restaurant not found"
}
```

---

## Menus API

All menu endpoints are nested under restaurants.

### List All Menus for a Restaurant

Get all menus for a specific restaurant.

**Endpoint:** `GET /api/restaurants/:restaurant_id/menus`

**Parameters:**
- `restaurant_id` (UUID) - Restaurant identifier

**Response:** `200 OK`

```json
[
  {
    "id": "880e8400-e29b-41d4-a716-446655440003",
    "restaurant_id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Margherita Pizza",
    "description": "Classic pizza with fresh mozzarella, tomato sauce, and basil",
    "price": "18.99",
    "category": "Main Course",
    "dietary_type": "veg",
    "created_at": "2025-12-10T12:00:00.000Z",
    "updated_at": "2025-12-10T12:00:00.000Z"
  },
  {
    "id": "990e8400-e29b-41d4-a716-446655440004",
    "restaurant_id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Spaghetti Carbonara",
    "description": "Creamy pasta with bacon, eggs, and parmesan cheese",
    "price": "22.99",
    "category": "Main Course",
    "dietary_type": "non_veg",
    "created_at": "2025-12-10T12:00:00.000Z",
    "updated_at": "2025-12-10T12:00:00.000Z"
  }
]
```

**Error Response:** `404 Not Found`

```json
{
  "error": "Restaurant not found"
}
```

### Get a Menu

Get details of a specific menu item.

**Endpoint:** `GET /api/restaurants/:restaurant_id/menus/:id`

**Parameters:**
- `restaurant_id` (UUID) - Restaurant identifier
- `id` (UUID) - Menu identifier

**Response:** `200 OK`

```json
{
  "id": "880e8400-e29b-41d4-a716-446655440003",
  "restaurant_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Margherita Pizza",
  "description": "Classic pizza with fresh mozzarella, tomato sauce, and basil",
  "price": "18.99",
  "category": "Main Course",
  "dietary_type": "veg",
  "created_at": "2025-12-10T12:00:00.000Z",
  "updated_at": "2025-12-10T12:00:00.000Z"
}
```

**Error Responses:**
- `404 Not Found` - Restaurant or menu not found

### Create a Menu

Create a new menu item for a restaurant.

**Endpoint:** `POST /api/restaurants/:restaurant_id/menus`

**Parameters:**
- `restaurant_id` (UUID) - Restaurant identifier

**Request Body:**

```json
{
  "menu": {
    "name": "New Menu Item",
    "description": "Delicious food description",
    "price": 20.99,
    "category": "Main Course",
    "dietary_type": "veg"
  }
}
```

**Dietary Type Values:**
- `veg` - Vegetarian
- `non_veg` - Non-vegetarian
- `vegan` - Vegan

**Response:** `201 Created`

```json
{
  "id": "aa0e8400-e29b-41d4-a716-446655440005",
  "restaurant_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "New Menu Item",
  "description": "Delicious food description",
  "price": "20.99",
  "category": "Main Course",
  "dietary_type": "veg",
  "created_at": "2025-12-10T12:00:00.000Z",
  "updated_at": "2025-12-10T12:00:00.000Z"
}
```

**Error Responses:**
- `404 Not Found` - Restaurant not found
- `422 Unprocessable Entity` - Validation errors

```json
{
  "errors": ["Name can't be blank", "Description can't be blank", "Price must be greater than 0"]
}
```

### Update a Menu

Update an existing menu item.

**Endpoint:** `PATCH /api/restaurants/:restaurant_id/menus/:id` or `PUT /api/restaurants/:restaurant_id/menus/:id`

**Parameters:**
- `restaurant_id` (UUID) - Restaurant identifier
- `id` (UUID) - Menu identifier

**Request Body:**

```json
{
  "menu": {
    "name": "Updated Menu Name",
    "price": 25.99
  }
}
```

**Response:** `200 OK`

```json
{
  "id": "880e8400-e29b-41d4-a716-446655440003",
  "restaurant_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Updated Menu Name",
  "description": "Classic pizza with fresh mozzarella, tomato sauce, and basil",
  "price": "25.99",
  "category": "Main Course",
  "dietary_type": "veg",
  "created_at": "2025-12-10T12:00:00.000Z",
  "updated_at": "2025-12-10T12:10:00.000Z"
}
```

**Error Responses:**
- `404 Not Found` - Restaurant or menu not found
- `422 Unprocessable Entity` - Validation errors

### Delete a Menu

Delete a menu item.

**Endpoint:** `DELETE /api/restaurants/:restaurant_id/menus/:id`

**Parameters:**
- `restaurant_id` (UUID) - Restaurant identifier
- `id` (UUID) - Menu identifier

**Response:** `204 No Content`

**Error Response:** `404 Not Found`

```json
{
  "error": "Menu not found"
}
```

---

## Metrics API

### Get Prometheus Metrics

Get application metrics in Prometheus format.

**Endpoint:** `GET /metrics`

**Response:** `200 OK`

**Content-Type:** `text/plain`

```
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET",path="/api/restaurants",status="200"} 10
http_requests_total{method="POST",path="/api/restaurants",status="201"} 5

# HELP http_request_duration_seconds HTTP request duration in seconds
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{method="GET",path="/api/restaurants",status="200",le="0.001"} 2
http_request_duration_seconds_bucket{method="GET",path="/api/restaurants",status="200",le="0.005"} 8
http_request_duration_seconds_bucket{method="GET",path="/api/restaurants",status="200",le="+Inf"} 10
http_request_duration_seconds_count{method="GET",path="/api/restaurants",status="200"} 10
http_request_duration_seconds_sum{method="GET",path="/api/restaurants",status="200"} 0.025
```

---

## Error Responses

### Standard Error Format

All error responses follow this format:

```json
{
  "error": "Error message"
}
```

or for validation errors:

```json
{
  "errors": ["Error message 1", "Error message 2"]
}
```

### HTTP Status Codes

- `200 OK` - Request successful
- `201 Created` - Resource created successfully
- `204 No Content` - Request successful, no content to return
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation errors
- `500 Internal Server Error` - Server error

---

## Data Models

### Restaurant

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `id` | UUID | Unique identifier | Auto-generated |
| `name` | String | Restaurant name | Yes |
| `location` | String | Restaurant location | Yes |
| `created_at` | DateTime | Creation timestamp | Auto-generated |
| `updated_at` | DateTime | Last update timestamp | Auto-generated |

### Menu

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `id` | UUID | Unique identifier | Auto-generated |
| `restaurant_id` | UUID | Parent restaurant ID | Yes |
| `name` | String | Menu item name | Yes |
| `description` | Text | Menu item description | Yes |
| `price` | Decimal | Price (must be > 0) | Yes |
| `category` | String | Menu category (e.g., "Appetizer", "Main Course", "Dessert") | No |
| `dietary_type` | Enum | Dietary type: `veg`, `non_veg`, or `vegan` | No (defaults to `veg`) |
| `created_at` | DateTime | Creation timestamp | Auto-generated |
| `updated_at` | DateTime | Last update timestamp | Auto-generated |

---

## Example Requests

### cURL Examples

**List all restaurants:**
```bash
curl -X GET http://localhost:3000/api/restaurants
```

**Create a restaurant:**
```bash
curl -X POST http://localhost:3000/api/restaurants \
  -H "Content-Type: application/json" \
  -d '{
    "restaurant": {
      "name": "Test Restaurant",
      "location": "Test City"
    }
  }'
```

**Get a restaurant:**
```bash
curl -X GET http://localhost:3000/api/restaurants/550e8400-e29b-41d4-a716-446655440000
```

**Create a menu:**
```bash
curl -X POST http://localhost:3000/api/restaurants/550e8400-e29b-41d4-a716-446655440000/menus \
  -H "Content-Type: application/json" \
  -d '{
    "menu": {
      "name": "Pizza",
      "description": "Delicious pizza",
      "price": 15.99,
      "category": "Main Course",
      "dietary_type": "veg"
    }
  }'
```

**Update a menu:**
```bash
curl -X PATCH http://localhost:3000/api/restaurants/550e8400-e29b-41d4-a716-446655440000/menus/880e8400-e29b-41d4-a716-446655440003 \
  -H "Content-Type: application/json" \
  -d '{
    "menu": {
      "price": 18.99
    }
  }'
```

**Delete a restaurant:**
```bash
curl -X DELETE http://localhost:3000/api/restaurants/550e8400-e29b-41d4-a716-446655440000
```

**Get metrics:**
```bash
curl -X GET http://localhost:3000/metrics
```

---

## Observability

### Logging

All API requests are automatically logged in JSON format with the following fields:
- `timestamp` - ISO8601 timestamp
- `method` - HTTP method
- `path` - Request path
- `status` - HTTP status code
- `duration_ms` - Response time in milliseconds
- `ip` - Client IP address
- `user_agent` - User agent string

### Metrics

The application automatically tracks:
- Request count by method, path, and status
- Request duration by method, path, and status

Metrics are available at `/metrics` endpoint in Prometheus format.
