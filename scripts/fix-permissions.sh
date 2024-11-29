#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

echo "Setting up directories..."

# Create all necessary directories
mkdir -p arduino_data/packages/builtin/{tools,hardware}
mkdir -p arduino_data/packages/chipKIT/tools/pic32-tools/1.43
mkdir -p arduino_data/packages/chipKIT/tools/pic32prog/1.0.0
mkdir -p arduino_data/packages/chipKIT/hardware/pic32/2.1.0
mkdir -p arduino_data/staging
mkdir -p arduino_data/user/libraries
mkdir -p tmp
mkdir -p dist

echo "Directory structure created!"
echo "You may now run: ./scripts/build-sketch.sh path/to/sketch.ino"