#!/bin/bash

set -euo pipefail

IMAGE_NAME="rust-workspace-image"
CONTAINER_NAME="rust-workspace-container"
SCRIPT_DIR="$(dirname -- "${BASH_SOURCE[0]}")"

cd "$SCRIPT_DIR"

already_in_container() {
	if [ -f /.dockerenv ] || [ -f /run/.containerenv ]; then
		return 0
	fi

	return 1
}

is_container_running() {
	podman ps --filter "name=$CONTAINER_NAME" --filter "status=running" --format "{{.Names}}" | grep -qx "$CONTAINER_NAME"
}

container_exists() {
	podman container exists "$CONTAINER_NAME"
}

container_uses_host_network() {
	[[ "$(podman inspect "$CONTAINER_NAME" --format "{{.HostConfig.NetworkMode}}" 2>/dev/null)" == "host" ]]
}

image_exists() {
	podman image exists "$IMAGE_NAME"
}

build_image() {
	echo "Image $IMAGE_NAME not found. Building..."
	podman build -f Containerfile -t "$IMAGE_NAME" .
}

create_container() {
	echo "Creating $CONTAINER_NAME"
	podman run \
		--detach \
		--interactive \
		--tty \
		--name "$CONTAINER_NAME" \
		--network host \
		--userns keep-id \
		--user root \
		--env "KERNEL_VERSION=$(uname -r)" \
		--volume "./workspace:/root/workspace" \
		"$IMAGE_NAME"
}

ensure_host_network_container() {
	if container_exists && ! container_uses_host_network; then
		echo "Recreating $CONTAINER_NAME with host network"
		podman stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
		podman rm "$CONTAINER_NAME" >/dev/null
	fi
}

enter_container() {
	if [[ $# -gt 0 ]]; then
		podman exec "$CONTAINER_NAME" "$@"
	else
		podman exec -it "$CONTAINER_NAME" zsh
	fi
}

if already_in_container; then
	echo "Already in container"
else
	if ! image_exists; then
		build_image
	fi

	ensure_host_network_container

	if is_container_running; then
		enter_container "$@"
	else
		if container_exists; then
			echo "Starting $CONTAINER_NAME"
			podman start "$CONTAINER_NAME"
		else
			create_container
		fi

		enter_container "$@"
	fi
fi
