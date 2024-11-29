#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

echo "Starting thorough cleanup..."

# Stop and remove all project containers
echo "Stopping Docker containers..."
docker compose down --remove-orphans

# Remove project images
echo "Removing Docker images..."
docker compose rm -f
docker rmi -f chipkit-docker-arduino-cli chipkit-docker-core-builder 2>/dev/null || true

# Remove build directories and artifacts using Docker to handle permissions
echo "Removing build directories and artifacts..."
docker run --rm -v "$(pwd):/workspace" ubuntu:22.04 sh -c "rm -rf /workspace/dist /workspace/arduino_data /workspace/tmp /workspace/.arduino15 /workspace/.cache"

# Create necessary directories without changing permissions
echo "Creating clean directories..."
mkdir -p tmp dist arduino_data

echo "Clean completed. Run the following commands to rebuild:"
echo "1. docker compose build --no-cache"
echo "2. ./scripts/build-core.sh"
echo "3. ./scripts/fix-platform.sh"