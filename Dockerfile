FROM ruby:2.5.1-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash

WORKDIR /usr/src/app

ADD . /usr/src/app

RUN bundle install

CMD ruby app.rb
