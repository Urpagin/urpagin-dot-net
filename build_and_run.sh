#!/bin/bash

# Pull the latest changes from Git
git pull

# Stop and remove the existing container if it exists
sudo docker stop urpagin-dot-net || true
sudo docker container rm urpagin-dot-net || true

# Build a new Docker image (ignore any failure if there's no existing image)
sudo docker build . -t urpagin-dot-net || true

# Run a new container
sudo docker run --name urpagin-dot-net -d -p 35037:3000 urpagin-dot-net
