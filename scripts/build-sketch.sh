#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-sketch>"
    exit 1
fi

SKETCH_PATH="$1"

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Run Arduino CLI compilation
docker-compose run --rm arduino-cli compile -b chipKIT:pic32:your_board "$SKETCH_PATH"
