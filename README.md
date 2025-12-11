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

## Linting
```bash
rake docker:lint        # Run RuboCop linter
```

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment.

### Workflows

#### 1. CI Workflow (`.github/workflows/ci.yml`)
Runs on:
- Push to `master`/`main` branch
- All pull requests

Jobs:
- **Lint**: Runs RuboCop to check code style
- **Test**: Runs RSpec test suite with PostgreSQL

#### 2. CD Workflow (`.github/workflows/cd.yml`)
Runs on:
- Push to `master`/`main` branch (deploys to QA)
- Tag creation (tags starting with `v*` - full production deployment)

### Deployment Process

#### QA Deployment (Automatic)
When code is pushed to `master`/`main`:
1. CI runs (lint + tests)
2. If CI passes → Deploy to QA environment
3. Integration tests run against QA

**No approval required** for QA deployments.

#### Production Deployment (Tag-based with Approvals)
To deploy to production:

1. **Create a release tag:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Deployment pipeline:**
   - CI runs (lint + tests)
   - Deploy to QA
   - Integration tests run
   - **Run migrations** (requires approval in `production` environment)
   - **Deploy canary** (requires approval in `production-canary` environment)
   - **Full production deployment** (requires approval in `production` environment)

### Required GitHub Configuration

#### Secrets
Configure these in **Settings → Secrets and variables → Actions**:

- `REGISTRY_URL` - Container registry URL (e.g., `registry.example.com`)
- `REGISTRY_USERNAME` - Registry username
- `REGISTRY_PASSWORD` - Registry password

#### Environments
Create these environments in **Settings → Environments**:

1. **`qa`** - QA environment
   - No approval required
   - Used for QA deployments

2. **`production`** - Production environment
   - **Required reviewers**: Add team members who can approve deployments
   - Used for migrations and full production deployments

3. **`production-canary`** - Canary deployment environment
   - **Required reviewers**: Add team members who can approve canary deployments
   - Used for canary releases (10% traffic)

### Deployment Workflow Details

#### QA Deployment Flow
```
Push to master/main
  ↓
CI (lint + test)
  ↓
Deploy to QA
  ↓
Integration Tests
```

#### Production Deployment Flow
```
Create tag (v*)
  ↓
CI (lint + test)
  ↓
Deploy to QA
  ↓
Integration Tests
  ↓
[APPROVAL REQUIRED] Run Migrations
  ↓
[APPROVAL REQUIRED] Deploy Canary (10% traffic)
  ↓
[APPROVAL REQUIRED] Full Production Deployment
```

### Manual Deployment Steps

If you need to deploy manually or troubleshoot:

1. **Build Docker image:**
   ```bash
   docker build -f Dockerfile -t kitchen:latest .
   ```

2. **Tag and push to registry:**
   ```bash
   docker tag kitchen:latest $REGISTRY_URL/kitchen:$TAG
   docker push $REGISTRY_URL/kitchen:$TAG
   ```

3. **Run migrations:**
   ```bash
   # Update with your deployment method
   kubectl exec -it deployment/kitchen -- bin/rails db:migrate
   ```

4. **Deploy application:**
   ```bash
   # Update with your deployment method (kubectl, helm, etc.)
   ```

### Monitoring Deployments

- **GitHub Actions**: View deployment status in the Actions tab
- **Prometheus Metrics**: Available at `/metrics` endpoint
- **JSON Logs**: All API requests are logged in JSON format

### Rollback Procedure

If a deployment fails:

1. **Immediate rollback:**
   ```bash
   # Revert to previous tag/image
   git tag v0.9.0  # Previous version
   git push origin v0.9.0
   ```

2. **Database rollback:**
   ```bash
   # Rollback last migration
   bin/rails db:rollback
   ```

## Service Dependencies
[TBD]
