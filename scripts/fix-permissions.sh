#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Get current user and group
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo "Fixing permissions for user $USER_ID:$GROUP_ID"

# Create necessary directories if they don't exist
mkdir -p arduino_data/packages/chipKIT/tools/pic32-tools/1.43/bin
mkdir -p arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/bin
mkdir -p arduino_data/user/libraries
mkdir -p arduino_data/staging
mkdir -p dist
mkdir -p tmp

# Fix ownership of all directories
sudo chown -R $USER_ID:$GROUP_ID \
    arduino_data \
    dist \
    tmp

# Fix directory permissions
find arduino_data -type d -exec chmod 755 {} \;
find dist -type d -exec chmod 755 {} \;
find tmp -type d -exec chmod 755 {} \;

# Fix file permissions
find arduino_data -type f -exec chmod 644 {} \;
find dist -type f -exec chmod 644 {} \;
find tmp -type f -exec chmod 644 {} \;

# Make specific files executable
if [ -d "arduino_data/packages/chipKIT/tools/pic32-tools/1.43/bin" ]; then
    chmod +x arduino_data/packages/chipKIT/tools/pic32-tools/1.43/bin/*
fi

if [ -d "arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/bin" ]; then
    chmod +x arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/bin/*
fi

echo "Permissions fixed!"
echo "Verifying key executables..."

# Verify key executables
for TOOL in \
    "arduino_data/packages/chipKIT/tools/pic32-tools/1.43/bin/pic32-g++" \
    "arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/bin/pic32prog"
do
    if [ -f "$TOOL" ]; then
        ls -l "$TOOL"
    else
        echo "Warning: $TOOL not found"
    fi
done