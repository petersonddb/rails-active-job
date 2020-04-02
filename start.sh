#!/bin/bash
set -e

if [ "$WORKER" = 'true' ]; then
  bundle exec sidekiq >> log/sidekiq.log
else
  rm -f /app/tmp/pids/server.pid
  bundle exec rails db:migrate
  bundle exec rails s -b '0.0.0.0'
fi
