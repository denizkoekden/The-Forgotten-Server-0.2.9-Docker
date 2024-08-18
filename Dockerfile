# Use an Ubuntu base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    liblua5.1-0 liblua5.1-dev lua-sql-mysql-dev lua-sql-mysql lua-sql-sqlite3-dev lua-sql-sqlite3 libmysqlclient-dev libboost1.74-all-dev libgmp-dev libxml2-dev \
    wget unzip

# Create directories for the server and data
RUN mkdir -p /opt/server /data

# Download and extract the server release
RUN wget https://github.com/denizkoekden/TheForgottenServer_0.2.9/releases/download/v1.0.0/server_release.zip -O /opt/server/server_release.zip && \
    unzip /opt/server/server_release.zip -d /opt/server && \
    rm /opt/server/server_release.zip

# Make the server binary executable
RUN chmod +x /opt/server/TheForgottenServer

# Set the dynamic linker path
ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/"

# Expose the port used by the server
EXPOSE 7171 7172

# Set the working directory
WORKDIR /opt/server

# Copy the config.lua and data directory to /data so they can be modified from outside
RUN cp -r /opt/server/config.lua /data/config.lua && cp -r /opt/server/data /data

# Import the SQL schema into MySQL (this will be done in the entrypoint)
COPY import_db.sh /opt/server/import_db.sh
RUN chmod +x /opt/server/import_db.sh

# Command to run the server, config.lua and data will be linked to the /data directory
CMD ["sh", "-c", "/opt/server/import_db.sh && ln -sf /data/config.lua ./config.lua && ln -sf /data/* ./data && ./TheForgottenServer"]



