#!/bin/bash
set -e

echo "Checking directory structure..."

# Check dist directory structure
echo "=== Checking dist directory ==="
ls -la dist/linux32/chipkit-core/pic32/compiler/pic32-tools/bin/
echo ""

# Check arduino_data directory structure
echo "=== Checking arduino_data directory ==="
ls -la arduino_data/packages/chipKIT/tools/pic32-tools/1.43/
echo ""

# Check inside arduino-cli container
echo "=== Checking paths inside arduino-cli container ==="
docker compose run --rm --entrypoint=/bin/sh arduino-cli -c '
echo "Compiler directory:";
ls -la /data/packages/chipKIT/tools/pic32-tools/1.43/;
echo "";
echo "Platform directory:";
ls -la /data/packages/chipKIT/hardware/pic32/2.1.0/;
'