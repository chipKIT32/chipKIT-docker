#!/bin/bash
set -e

# Default values
PORT=""
BOARD=${BOARD:-"chipKIT:pic32:chipkit_DP32"}
BUILD_PATH=""

# Function to display usage
usage() {
    echo "Usage: $0 [options] <sketch>"
    echo "Options:"
    echo "  -p, --port <port>    Specify the upload port (e.g., /dev/ttyACM0)"
    echo "  -h, --help           Display this help message"
    echo ""
    echo "Environment variables:"
    echo "  BOARD               Set the board FQBN (currently: $BOARD)"
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

# Check paths before proceeding
echo "Checking required paths and tools..."
if ! ./scripts/check-paths.sh; then
    echo "Error: Required paths are missing. Please fix the issues above before uploading."
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

echo "Using board: $BOARD"
echo "Using port: $PORT"

# Create build directory
SKETCH_NAME=$(basename "${SKETCH%.*}")
BUILD_PATH="tmp/build/${SKETCH_NAME}"
mkdir -p "$BUILD_PATH"

# Check if sketch is already built
if [ ! -f "$BUILD_PATH/${SKETCH_NAME}.ino.hex" ]; then
    echo "Sketch not built yet. Building now..."
    # Build the sketch
    docker compose run --rm arduino-cli compile \
        --fqbn "$BOARD" \
        --build-path "$BUILD_PATH" \
        "$SKETCH"

    if [ $? -ne 0 ]; then
        echo "Build failed! Aborting upload."
        exit 1
    fi
else
    echo "Using existing build at $BUILD_PATH"
fi

echo "Uploading sketch..."

# Create a temporary docker-compose override for upload
cat > docker-compose.upload.override.yaml <<EOF
services:
  arduino-cli:
    environment:
      - ARDUINO_UPLOAD_TOOL_PATH=/data/packages/chipKIT/hardware/pic32/2.1.0/tools/bin/pic32prog
    devices:
      - $PORT:$PORT
    group_add:
      - dialout
EOF

# Echo the upload command that will be executed
echo "Executing upload command:"
echo "docker compose -f compose.yaml -f docker-compose.upload.override.yaml run --rm arduino-cli upload -b \"$BOARD\" -p \"$PORT\" --input-dir \"$BUILD_PATH\" \"$SKETCH\""

# Use the override file for uploading
docker compose -f compose.yaml -f docker-compose.upload.override.yaml run --rm \
    arduino-cli upload \
    -b "$BOARD" \
    -p "$PORT" \
    --input-dir "$BUILD_PATH" \
    "$SKETCH" --verbose

RET=$?

# Clean up the temporary override file
rm docker-compose.upload.override.yaml

if [ $RET -eq 0 ]; then
    echo "Upload successful!"
else
    echo "Upload failed with error code $RET"
    echo "Debugging information:"
    echo "1. Checking pic32prog path:"
    docker compose run --rm --entrypoint=/bin/sh arduino-cli -c "
    echo 'Actual location:';
    ls -l /data/packages/chipKIT/hardware/pic32/2.1.0/tools/bin/pic32prog 2>/dev/null || echo 'Not found';
    echo 'Looking for tool in:';
    find /data -name pic32prog -type f
    "
    exit $RET
fi