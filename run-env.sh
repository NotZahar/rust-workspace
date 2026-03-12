#!/bin/bash

set -euo pipefail

SERVICE_NAME="rust-workspace"
IMAGE_NAME="rust-workspace-image"
CONTAINER_NAME="rust-workspace-container"

already_in_container() {
	if [ -f /.dockerenv ] || [ -f /run/.containerenv ]; then
		return 0
	fi

	return 1
}

is_container_running() {
	podman ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q $CONTAINER_NAME
}

if already_in_container; then
	echo "Already in container"
else
	if is_container_running; then
		echo "Attaching to $CONTAINER_NAME"
		podman exec -it $CONTAINER_NAME /bin/zsh
	else
		if [[ -z "$(podman images -q $IMAGE_NAME 2>/dev/null)" ]]; then
			echo "Image $IMAGE_NAME not found. Building..."
			COMPOSE_FLAGS="--build"
		else
			echo "Image $IMAGE_NAME found. Starting container..."
			COMPOSE_FLAGS=""
		fi

		KERNEL_VERSION=$(uname -r) podman-compose --in-pod false up -d $COMPOSE_FLAGS $SERVICE_NAME
		podman exec -it $CONTAINER_NAME /bin/zsh
	fi
fi
