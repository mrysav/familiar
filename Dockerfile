FROM ruby:2.3.3

# for postgres, nokogiri and nodejs
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs

# for process management
RUN gem install foreman

ENV APP_HOME /familiar
ENV RAILS_ENV docker

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN gem install bundler
RUN bundle install

ADD . $APP_HOME
