FROM ruby:2.5.1-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash

WORKDIR /usr/src/app

ADD Gemfile Gemfile.lock /usr/src/app/
RUN bundle install

ADD . /usr/src/app

CMD ruby app.rb
