#!/bin/bash
set -e

usage() {
    echo "Usage: $0 [options] <path-to-sketch>"
    echo "Options:"
    echo "  -p, --port <port>  Specify the USB port (default: /dev/ttyACM0)"
    echo ""
    echo "Environment variables:"
    echo "  BOARD    Board FQBN (e.g., chipKIT:pic32:fubarino_mini)"
    echo "  PORT     Alternative to --port option"
    exit 1
}

# Parse command line arguments
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}"

# Check required parameters
if [ -z "$1" ]; then
    echo "Error: No sketch specified"
    usage
fi

if [ -z "$BOARD" ]; then
    echo "Error: BOARD environment variable not set"
    usage
fi

SKETCH="$1"
PORT=${PORT:-"/dev/ttyACM0"}

# Verify sketch exists
if [ ! -f "$SKETCH" ]; then
    echo "Error: Sketch file not found: $SKETCH"
    exit 1
fi

# Extract sketch name and create build path
SKETCH_NAME=$(basename "${SKETCH%.*}")
BUILD_DIR="dist/${SKETCH_NAME}"
COMPILED_SKETCH="${BUILD_DIR}/${SKETCH_NAME}.ino.hex"

# Ensure the sketch is built first
echo "Building sketch first..."
./scripts/build-sketch.sh --build-dir "$SKETCH"

# Verify compiled sketch exists
if [ ! -f "$COMPILED_SKETCH" ]; then
    echo "Error: Compiled sketch not found: $COMPILED_SKETCH"
    exit 1
fi

echo "Using board: $BOARD"
echo "Using port: $PORT"
echo "Uploading sketch from: $COMPILED_SKETCH"

# Check if port exists
if [ ! -e "$PORT" ]; then
    echo "Error: Port $PORT not found"
    echo "Available ports:"
    ls -l /dev/ttyACM* 2>/dev/null || echo "No ACM ports found"
    ls -l /dev/ttyUSB* 2>/dev/null || echo "No USB ports found"
    exit 1
fi

# Use the upload-specific compose file
docker compose -f compose.yaml -f compose.upload.yaml \
    run --rm arduino-cli upload \
    -p "$PORT" \
    -b "$BOARD" \
    --input-dir "${BUILD_DIR}" \
    "$SKETCH"

# Check upload status
if [ $? -eq 0 ]; then
    echo "Upload successful!"
else
    echo "Upload failed!"
    exit 1
fi