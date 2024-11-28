#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Wait for the core build to complete if it hasn't already
if [ ! -d "dist/linux32/chipkit-core/pic32" ]; then
    echo "Core not built yet. Building..."
    ./scripts/build-core.sh
fi

# Update the platform.txt file to use the correct paths
PLATFORM_FILE="dist/linux32/chipkit-core/pic32/platform.txt"

# Create a backup
cp "$PLATFORM_FILE" "${PLATFORM_FILE}.backup"

# Update the compiler paths
sed -i 's|{runtime.tools.pic32-tools.path}/bin/|{runtime.tools.pic32-tools.path}/|g' "$PLATFORM_FILE"
sed -i 's|{runtime.hardware.path}/tools/bin|{runtime.tools.pic32-tools.path}|g' "$PLATFORM_FILE"

echo "Platform configuration updated."
