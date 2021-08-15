# Production image for Pinhole. Build: docker build -t pinhole .
ARG RUBY_VERSION=3.4.12
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /app
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libpq5 libyaml-0-2 && \
    rm -rf /var/lib/apt/lists/*
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

FROM base AS gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

FROM gems AS build
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install
COPY . .
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

# Test image with every gem group, used by `docker compose run --rm test`.
FROM gems AS test
ENV RAILS_ENV=test BUNDLE_WITHOUT=""
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install
COPY . .
CMD ["sh", "-c", "bin/rails db:prepare && bin/rails test && bundle exec rubocop"]

FROM base AS app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app
RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p public/uploads tmp log && \
    chown -R rails:rails public/uploads tmp log
USER rails
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
