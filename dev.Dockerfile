FROM ruby:3.2.0-alpine

# Install dependencies
RUN apk add --no-cache \
  postgresql-client \
  build-base \
  postgresql-dev \
  tzdata \
  git

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

