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

# Update tool paths - note we don't modify compiler.path as it's already correct
sed -i 's|{runtime.hardware.path}/tools/bin/pic32prog|{runtime.tools.pic32prog.path}/pic32prog|g' "$PLATFORM_FILE"

# Ensure the arduino_data directory structure exists
mkdir -p arduino_data/packages/chipKIT/tools/pic32-tools/1.43
mkdir -p arduino_data/packages/chipKIT/tools/pic32prog/1.0.0

# Copy necessary files
echo "Setting up compiler tools..."
cp -r dist/linux32/chipkit-core/pic32/compiler/pic32-tools/* \
   arduino_data/packages/chipKIT/tools/pic32-tools/1.43/

echo "Setting up pic32prog..."
cp dist/linux32/chipkit-core/pic32/tools/bin/pic32prog \
   arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/

# Make executables actually executable
find arduino_data/packages/chipKIT/tools/pic32-tools/1.43/bin -type f -exec chmod +x {} \;
chmod +x arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/pic32prog

echo "Platform configuration updated."
echo "Compiler tools and pic32prog installed to correct locations."

# Display final paths for verification
echo -e "\nVerifying setup..."
echo "Compiler path:"
ls -l arduino_data/packages/chipKIT/tools/pic32-tools/1.43/bin/pic32-g++
echo "Pic32prog path:"
ls -l arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/pic32prog