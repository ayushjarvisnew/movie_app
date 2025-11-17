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


# Expose port
EXPOSE 80

# Command for Render (production)
CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails assets:precompile && bundle exec rails server -b 0.0.0.0 -p 80 -e production"]