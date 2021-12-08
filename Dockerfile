# syntax=docker/dockerfile:1
FROM ruby:2.7.4
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]