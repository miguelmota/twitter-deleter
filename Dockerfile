FROM ruby:2.4.0
RUN gem install bundler:2.0.1
RUN mkdir /usr/app
WORKDIR /usr/app
COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/
RUN bundle install
COPY . /usr/app
CMD ruby deleter.rb
