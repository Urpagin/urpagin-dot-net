#!/bin/bash

container_name="urpagin-dot-net"
container_port=35000

# Check if the container exists
if sudo docker inspect $container_name &> /dev/null; then
    echo "Removing container: $container_name"
    sudo docker rm -f $container_name
else
    echo "Container $container_name does not exist, skipping removal."
fi

# Build the new image
if sudo docker build -t $container_name:latest .; then
    echo "Build succeeded, running container..."
    # Run the new container instance
    if sudo docker run --name $container_name -d -p $container_port:8000 --restart=unless-stopped $container_name:latest; then
        echo "Container is up and running on port $container_port"
    else
        echo "Failed to run container"
        exit 1
    fi
else
    echo "Build failed"
    exit 1
fi
