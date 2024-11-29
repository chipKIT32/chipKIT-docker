#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

echo "Setting up platform and tools..."

# Ensure base directories exist
mkdir -p arduino_data/packages/chipKIT/tools/pic32prog/1.0.0

# Copy pic32prog to the correct location
if [ -f "dist/linux32/chipkit-core/pic32/tools/bin/pic32prog" ]; then
    cp dist/linux32/chipkit-core/pic32/tools/bin/pic32prog \
       arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/
    chmod +x arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/pic32prog
elif [ -f "dist/linux32/chipkit-core/pic32/tools/pic32prog" ]; then
    cp dist/linux32/chipkit-core/pic32/tools/pic32prog \
       arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/
    chmod +x arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/pic32prog
else
    echo "Error: Could not find pic32prog in expected locations"
    exit 1
fi

echo "Platform setup complete. Verifying pic32prog location:"
ls -l arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/pic32prog