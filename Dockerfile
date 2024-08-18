# Use an Ubuntu base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    liblua5.1-0 libmysqlclient-dev libboost-system-dev libboost-thread-dev libboost-regex1.74-dev libgmp-dev libxml2-dev \
    wget unzip

# Create directories for the server and data
RUN mkdir -p /opt/server /data

# Download and extract the server release
RUN wget https://github.com/denizkoekden/TheForgottenServer_0.2.9/releases/download/v1.0.0/server_release.zip -O /opt/server/server_release.zip && \
    unzip /opt/server/server_release.zip -d /opt/server && \
    rm /opt/server/server_release.zip

# Make the server binary executable
RUN chmod +x /opt/server/TheForgottenServer

# Copy the config.lua to /data so it can be modified from outside
RUN cp /opt/server/config.lua /data/config.lua

# Set the dynamic linker path
ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/"

# Expose the port used by the server
EXPOSE 7171 7172

# Set the working directory
WORKDIR /opt/server

# Command to run the server, config.lua will be linked to the /data directory
CMD ["sh", "-c", "ln -sf /data/config.lua ./config.lua && ./TheForgottenServer"]
