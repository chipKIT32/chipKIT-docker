#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-sketch>"
    echo "Set BOARD environment variable to specify board (e.g., BOARD='chipKIT:pic32:fubarino_sd')"
    exit 1
fi

SKETCH_PATH="$1"

# Default board is DP32 but can be overridden by BOARD environment variable
BOARD=${BOARD:-"chipKIT:pic32:dp32"}

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Remove any leading ./ from the sketch path if present
SKETCH_PATH="${SKETCH_PATH#./}"

echo "Using board: $BOARD"
echo "Compiling sketch: $SKETCH_PATH"

# Run Arduino CLI compilation with the specified board
docker compose run --rm arduino-cli compile --fqbn "$BOARD" "$SKETCH_PATH"

# Check the exit status
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
else
    echo "Compilation failed!"
    exit 1
fi
