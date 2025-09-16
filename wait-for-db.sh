#!/bin/sh
echo "Waiting for MySQL to be ready at $DB_HOST:$DB_PORT..."
DB_HOST=${DB_HOST:-3.39.50.163}
DB_PORT=${DB_PORT:-3306}
until nc -z $DB_HOST $DB_PORT; do
  echo "MySQL is unavailable - sleeping"
  sleep 2
done
echo "MySQL is up - executing command"