#!/bin/bash
set -e #exit on error

docker-compose build
docker-compose run web-app bundle exec rspec