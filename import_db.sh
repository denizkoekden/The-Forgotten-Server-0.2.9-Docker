#!/bin/bash

# Check if the database has already been imported
if [ ! -f /data/db_imported ]; then
    echo "Importing forgottenserver.sql into MySQL..."
    mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < /opt/server/forgottenserver.sql
    touch /data/db_imported
    echo "Database import complete."
else
    echo "Database already imported."
fi
