#!/bin/bash
set -e

git pull

# Rebuild & recreate your service in one step
sudo docker-compose up -d --build urpagin-dot-net
