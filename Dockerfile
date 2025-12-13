# Multi-stage build for production
FROM ruby:3.2.0-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  git \
  tzdata

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Production stage
FROM ruby:3.2.0-alpine

# Install runtime dependencies only
RUN apk add --no-cache \
  postgresql-client \
  tzdata \
  && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

# Set working directory
WORKDIR /app

# Copy gems from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy application code
COPY --chown=app:app . .

# Switch to non-root user
USER app

# Expose port
EXPOSE 3000

# Default command
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
