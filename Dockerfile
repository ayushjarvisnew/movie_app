## Use the official Ruby image
#FROM ruby:3.2
#
## Set working directory inside container
#WORKDIR /app
#
## Install Node.js, Yarn, and PostgreSQL client
#RUN apt-get update -qq && \
#    apt-get install -y curl gnupg && \
#    mkdir -p /etc/apt/keyrings && \
#    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg -o /etc/apt/keyrings/yarn.gpg && \
#    echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" \
#      | tee /etc/apt/sources.list.d/yarn.list && \
#    apt-get update -qq && \
#    apt-get install -y nodejs yarn postgresql-client && \
#    rm -rf /var/lib/apt/lists/*
#
## Copy Gemfile and Gemfile.lock first for caching
#COPY Gemfile* ./
#
## Install Ruby gems
#RUN bundle install --without development test && gem install foreman
#
## Copy the rest of the Rails app
#COPY . .
#
## Set environment
#ENV RAILS_ENV=production
#ENV RACK_ENV=production
#ENV NODE_ENV=production
#ENV PORT=80
#
## Expose port 80 (Render expects this)
#EXPOSE 80
#
## Start Rails production server
#CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails db:seed && bundle exec rails assets:precompile && bundle exec rails server -b 0.0.0.0 -p 80 -e production"]

# Use the official Ruby image
FROM ruby:3.2

# Set working directory inside container
WORKDIR /app

# Install Node.js, Corepack, and PostgreSQL client (REMOVE yarn repo)
RUN apt-get update -qq && \
    apt-get install -y curl gnupg nodejs postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# --- Enable Corepack + Install correct Yarn version ---
RUN corepack enable
RUN corepack prepare yarn@4.11.0 --activate

# Copy package files first (better caching)
COPY package.json yarn.lock ./

# Install JS dependencies with Yarn 4
RUN yarn install

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install --without development test && gem install foreman

# Copy the rest of the app
COPY . .

# Set environment
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV NODE_ENV=production
ENV PORT=80

# Precompile assets (important for Render)
RUN bundle exec rails assets:precompile

# Expose port
EXPOSE 80

# Run migrations on startup, then server
CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails db:seed && bundle exec rails server -b 0.0.0.0 -p 80 -e production"]
