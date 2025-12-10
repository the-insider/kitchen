# Kitchen

Kitchen represents the kitchen onboarded to Atlas. It manages the kitchen inventory and kitchen operations from orders to inventory management.

## Prerequisites
1. Ensure that ruby version is installed. Required version: `ruby-3.2.0`
2. If you need to manage ruby multiple versions, use [rbenv](https://github.com/rbenv/rbenv?tab=readme-ov-file#installation)
3. Ensure Docker and Docker Compose are installed. We use Docker to run the application and dependency services.
    * PostgreSQL 15 (via Docker)

## Configuration
1. We manage the configuration using Figaro.
Check `config/application.yml` for application specific configuration.

## Docker Setup

This application uses Docker Compose for local development. The setup includes:
- **PostgreSQL 15** database service
- **Rails API** application service

### Docker Compose Services

- `db`: PostgreSQL database
- `api`: Rails API application

### Using Rake Tasks (Recommended)

We provide rake tasks that automatically start Docker services and run commands:

#### Starting Services
```bash
rake docker:up          # Start database service
rake docker:down        # Stop all services
rake docker:build       # Build Docker images
```

#### Running the Application
```bash
rake docker:server      # Start Rails server (starts db automatically)
```

#### Database Operations
```bash
rake docker:db:create   # Create database
rake docker:db:drop     # Drop database
rake docker:db:reset    # Drop, create, and migrate database
rake docker:migrate     # Run database migrations
rake docker:db:seed     # Run database seeds
```

#### Development Tools
```bash
rake docker:console     # Open Rails console
rake docker:test        # Run test suite
rake docker:exec[command]  # Run any Rails command
                        # Example: rake docker:exec['generate model User name:string']
```

#### Logs
```bash
rake docker:logs        # View Docker logs
```

### Manual Docker Commands

If you prefer to use Docker Compose directly:

#### Start Services
```bash
docker-compose up -d db              # Start database only
docker-compose up -d                 # Start all services
docker-compose down                  # Stop all services
```

#### Run Rails Commands
```bash
# Start Rails server
docker-compose run --service-ports api bin/rails server -b 0.0.0.0

# Open Rails console
docker-compose run api bin/rails console

# Run migrations
docker-compose run api bin/rails db:migrate

# Create database
docker-compose run api bin/rails db:create

# Run any Rails command
docker-compose run api bin/rails <command>
```

**Note:** The `--service-ports` flag is required when running the server to expose port 3000.

## Database Setup

### Initial Setup
```bash
rake docker:db:create   # Create the database
rake docker:migrate     # Run migrations (enables UUID extension)
```

The application uses **PostgreSQL with UUID primary keys**. The UUID extension (`pgcrypto`) is automatically enabled when you run migrations.

## How to run the test suite
```bash
rake docker:test
```

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

