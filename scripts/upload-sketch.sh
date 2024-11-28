#!/bin/bash
set -e

# Default values
PORT=""
BOARD=${BOARD:-"chipKIT:pic32:chipkit_DP32"}
BUILD_PATH=""

# Function to check upload tool
check_upload_tool() {
    echo "Checking upload tool configuration..."
    docker compose run --rm --entrypoint="" arduino-cli /bin/sh -c "\
        echo 'Looking for pic32prog in:'; \
        ls -la /home/arduino/arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/ 2>/dev/null || echo 'pic32prog directory not found'; \
        echo ''; \
        echo 'Core files location:'; \
        ls -la /home/arduino/arduino_data/packages/chipKIT/hardware/pic32/2.1.0/ || echo 'Core directory not found'; \
        echo ''; \
        echo 'Tools directory:'; \
        ls -la /home/arduino/arduino_data/packages/chipKIT/tools/ || echo 'Tools directory not found'"
}

# Function to display usage
usage() {
    echo "Usage: $0 [options] <sketch>"
    echo "Options:"
    echo "  -p, --port <port>    Specify the upload port (e.g., /dev/ttyACM0)"
    echo "  -h, --help           Display this help message"
    echo ""
    echo "Environment variables:"
    echo "  BOARD               Set the board FQBN (currently: $BOARD)"
    echo ""
    echo "Example:"
    echo "  $0 -p /dev/ttyACM0 ./sketches/blink/blink.ino"
    echo "  BOARD=\"chipKIT:pic32:fubarino_mini\" $0 -p /dev/ttyACM0 ./sketches/blink/blink.ino"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            SKETCH="$1"
            shift
            ;;
    esac
done

# Validate inputs
if [ -z "$SKETCH" ]; then
    echo "Error: No sketch specified"
    usage
    exit 1
fi

if [ -z "$PORT" ]; then
    # Try to auto-detect port
    if [ -e "/dev/ttyACM0" ]; then
        PORT="/dev/ttyACM0"
    elif [ -e "/dev/ttyUSB0" ]; then
        PORT="/dev/ttyUSB0"
    else
        echo "Error: No port specified and could not auto-detect. Please specify port with -p option"
        echo "Available ports:"
        ls -1 /dev/ttyACM* /dev/ttyUSB* 2>/dev/null || echo "No ACM or USB ports found"
        exit 1
    fi
fi

# Verify port exists
if [ ! -e "$PORT" ]; then
    echo "Error: Port $PORT does not exist"
    echo "Available ports:"
    ls -1 /dev/ttyACM* /dev/ttyUSB* 2>/dev/null || echo "No ACM or USB ports found"
    exit 1
fi

echo "Using board: $BOARD"
echo "Using port: $PORT"

# Create build directory with proper permissions
SKETCH_NAME=$(basename "${SKETCH%.*}")
BUILD_PATH="/workspace/tmp/build/${SKETCH_NAME}"

# Ensure tmp directory exists with proper permissions
echo "Setting up build environment..."
mkdir -p tmp
docker compose run --rm --entrypoint="" arduino-cli mkdir -p /workspace/tmp/build/${SKETCH_NAME}

# Build the sketch with specified build path
echo "Building sketch..."
docker compose run --rm arduino-cli compile \
    --fqbn "$BOARD" \
    --build-path "$BUILD_PATH" \
    --build-cache-path "/workspace/tmp/cache" \
    "$SKETCH"

if [ $? -ne 0 ]; then
    echo "Build failed! Aborting upload."
    exit 1
fi

check_upload_tool


echo "Uploading sketch..."

# Create a temporary docker-compose override for the specific port
cat > docker-compose.upload.override.yaml <<EOF
services:
  arduino-cli:
    devices:
      - $PORT:$PORT
    group_add:
      - dialout
EOF

# Use the override file for uploading
docker compose -f compose.yaml -f docker-compose.upload.override.yaml run --rm arduino-cli upload \
    --fqbn "$BOARD" \
    --port "$PORT" \
    --input-dir "$BUILD_PATH" \
    "$SKETCH"

RET=$?

# Clean up the temporary override file
rm docker-compose.upload.override.yaml

exit $RET