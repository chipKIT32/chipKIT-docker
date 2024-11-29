#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Create required directories with correct ownership
mkdir -p tmp dist
chmod 777 tmp dist

echo "Starting core build..."
docker compose run --rm core-builder

if [ $? -eq 0 ]; then
    echo "ChipKIT core built successfully!"
else
    echo "Build failed!"
    exit 1
fi