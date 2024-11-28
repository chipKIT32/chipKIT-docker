#!/bin/bash
set -e

usage() {
    echo "Usage: $0 [options] <path-to-sketch>"
    echo "Options:"
    echo "  --build-dir         Create separate build directory in dist/ with sketch name"
    echo ""
    echo "Set BOARD environment variable to specify board FQBN, examples:"
    echo "  BOARD='chipKIT:pic32:fubarino_sd'    (Fubarino SD)"
    echo "  BOARD='chipKIT:pic32:chipkit_DP32'   (chipKIT DP32)"
    echo "  BOARD='chipKIT:pic32:chipkit_uc32'   (chipKIT uC32)"
    echo "  BOARD='chipKIT:pic32:chipkit_WF32'   (chipKIT WF32)"
    echo "  BOARD='chipKIT:pic32:chipkit_WiFire' (chipKIT WiFire)"
    echo "  BOARD='chipKIT:pic32:mega_pic32'     (chipKIT MAX32)"
    echo "  BOARD='chipKIT:pic32:uno_pic32'      (chipKIT UNO32)"
    exit 1
}

# Parse command line arguments
BUILD_DIR=false
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --build-dir)
            BUILD_DIR=true
            shift
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

if [ -z "$1" ]; then
    usage
fi

SKETCH_PATH="$1"

# Default board is chipKIT DP32 but can be overridden by BOARD environment variable
BOARD=${BOARD:-"chipKIT:pic32:chipkit_DP32"}

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Remove any leading ./ from the sketch path if present
SKETCH_PATH="${SKETCH_PATH#./}"

echo "Using board: $BOARD"
echo "Compiling sketch: $SKETCH_PATH"

# Prepare Arduino CLI command
ARDUINO_CMD="docker compose run --rm arduino-cli compile --fqbn \"$BOARD\""

if [ "$BUILD_DIR" = true ]; then
    # Extract sketch name from path (assumes last directory is sketch name)
    SKETCH_NAME=$(basename "$(dirname "$SKETCH_PATH")")
    ARDUINO_CMD+=" -e --output-dir dist/$SKETCH_NAME"
fi

ARDUINO_CMD+=" \"$SKETCH_PATH\""

# Run Arduino CLI compilation
eval $ARDUINO_CMD

# Check the exit status
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
else
    echo "Compilation failed!"
    exit 1
fi