#!/bin/bash

# Wait for MySQL to be ready
until mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;" > /dev/null 2>&1; do
  echo "Waiting for MySQL..."
  sleep 3
done

# Check if the database has already been imported
if [ ! -f /data/db_imported ]; then
    echo "Importing forgottenserver.sql into MySQL..."
    mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < /opt/server/forgottenserver.sql
    touch /data/db_imported
    echo "Database import complete."
else
    echo "Database already imported."
fi
