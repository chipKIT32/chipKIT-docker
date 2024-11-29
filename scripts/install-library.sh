#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "Usage: $0 \"library name\""
    echo "Example: $0 \"DHT sensor library\""
    exit 1
fi

LIBRARY_NAME="$1"

echo "Installing library: $LIBRARY_NAME"

# Install library using arduino-cli
docker compose run --rm arduino-cli lib install "$LIBRARY_NAME"

# List installed libraries without requiring sudo
docker compose run --rm arduino-cli lib list

echo "Library installation completed!"