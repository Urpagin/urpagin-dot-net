#!/bin/sh

# Remove any existing container named "urpagin-dot-net"
sudo docker rm -f urpagin-dot-net || true

# Build the new image
sudo docker build . -t urpagin-dot-net

# Run the new container
sudo docker run --name urpagin-dot-net -d -p 35037:3000 urpagin-dot-net
