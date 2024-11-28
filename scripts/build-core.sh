#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Build the ChipKIT core
docker compose run --rm core-builder

echo "ChipKIT core built successfully!"
