#!/bin/bash

# Stop any running containers
docker compose down

# Remove build directories
rm -rf dist/
rm -rf arduino_data/
rm -rf tmp/
rm -rf .arduino15/

echo "Clean completed. Run build-core.sh to rebuild."