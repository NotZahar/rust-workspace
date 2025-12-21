#!/bin/bash

IMAGE_NAME="rust-workspace-image"
CONTAINER_NAME="rust-workspace-container"

docker stop "$CONTAINER_NAME"
docker rm "$CONTAINER_NAME"
docker rmi "$IMAGE_NAME"
