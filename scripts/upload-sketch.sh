#!/bin/bash

if [ -z "$BOARD" ]; then
    echo "Error: BOARD environment variable not set"
    echo "Usage: BOARD=\"chipKIT:pic32:chipkit_uc32\" $0 <sketch>"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Error: No sketch specified"
    echo "Usage: BOARD=\"chipKIT:pic32:chipkit_uc32\" $0 <sketch>"
    exit 1
fi

SKETCH="$1"
echo "Using board: $BOARD"
echo "Uploading sketch: $SKETCH"

# Use the upload-specific compose file
docker-compose -f compose.yaml -f compose.upload.yaml run --rm arduino-cli upload -b "$BOARD" "$SKETCH"
