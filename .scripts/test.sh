#!/bin/bash
set -e #exit on error

docker-compose run web-app bundle exec rspec