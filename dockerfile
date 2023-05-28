# Use a Ruby base image with the desired version
FROM ruby:3.1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       nodejs

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install project dependencies
RUN gem install bundler:2.3.6
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the application code to the container
COPY . .

# Expose the port on which your Rails API will run
EXPOSE 3000

# Set environment variables, if necessary
ENV RAILS_ENV=development

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
