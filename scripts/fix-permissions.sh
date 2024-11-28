#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

# Create directories with proper permissions
sudo mkdir -p dist tmp arduino_data
sudo chown -R $USER:$USER dist tmp arduino_data

# Ensure write permissions
chmod -R u+rw dist tmp arduino_data

echo "Permissions fixed. Now run:"
echo "1. docker compose build"
echo "2. ./scripts/build-core.sh"
echo "3. ./scripts/build-sketch.sh <your-sketch>"