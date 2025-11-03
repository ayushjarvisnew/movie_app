# Use the official Ruby image
FROM ruby:3.2

# Set working directory inside container
WORKDIR /app

# Install Node.js, Yarn, and PostgreSQL client
RUN apt-get update -qq && \
    apt-get install -y curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg -o /etc/apt/keyrings/yarn.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" \
      | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y nodejs yarn postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock first for caching
COPY Gemfile* ./

# Install Ruby gems
RUN bundle install

# Copy the rest of the Rails app
COPY . .

# Expose Rails default port
EXPOSE 3000

# Start Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
