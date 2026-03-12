#!/bin/bash

set -euo pipefail

IMAGE_NAME="rust-workspace-image"
CONTAINER_NAME="rust-workspace-container"

podman stop "$CONTAINER_NAME" 2>/dev/null || true
podman rm "$CONTAINER_NAME" 2>/dev/null || true
podman rmi "$IMAGE_NAME" 2>/dev/null || true
