#!/bin/bash
set -e

# Utility functions
check_path() {
    local path="$1"
    local description="$2"
    local required="${3:-false}"
    
    if [ -e "$path" ]; then
        if [ -d "$path" ]; then
            echo "✓ Found directory: $description"
            echo "  → $path"
            ls -la "$path" | head -n 4
        else
            echo "✓ Found file: $description"
            echo "  → $path"
            ls -la "$path"
        fi
        echo ""
    else
        if [ "$required" = "true" ]; then
            echo "✗ ERROR: Missing required $description"
            echo "  → $path"
            echo ""
            MISSING_REQUIRED=true
        else
            echo "! Warning: Missing optional $description"
            echo "  → $path"
            echo ""
        fi
    fi
}

check_executable() {
    local path="$1"
    local description="$2"
    local required="${3:-false}"
    
    if [ -f "$path" ]; then
        if [ -x "$path" ]; then
            echo "✓ Found executable: $description"
            echo "  → $path"
            ls -la "$path"
            echo "File type: $(file "$path")"
            echo ""
        else
            echo "! Warning: Found but not executable: $description"
            echo "  → $path"
            ls -la "$path"
            echo ""
            if [ "$required" = "true" ]; then
                MISSING_REQUIRED=true
            fi
        fi
    else
        if [ "$required" = "true" ]; then
            echo "✗ ERROR: Missing required executable: $description"
            echo "  → $path"
            echo ""
            MISSING_REQUIRED=true
        else
            echo "! Warning: Missing optional executable: $description"
            echo "  → $path"
            echo ""
        fi
    fi
}

# Ensure we're in the project root
cd "$(dirname "$0")/.."

echo "=== ChipKIT Path Checker ==="
echo "Checking all required paths and executables..."
echo ""

MISSING_REQUIRED=false

echo "=== Build Directories ==="
check_path "dist" "Build output directory" true
check_path "tmp" "Temporary directory" true
check_path "arduino_data" "Arduino data directory" true

echo "=== Core Files ==="
check_path "dist/linux32/chipkit-core/pic32" "ChipKIT core directory" true
check_path "dist/linux32/chipkit-core/pic32/platform.txt" "Platform configuration" true

echo "=== Compiler Tools ==="
COMPILER_BASE="dist/linux32/chipkit-core/pic32/compiler"
check_path "$COMPILER_BASE" "Compiler base directory" true

# Check for both possible compiler directory structures
if [ -d "$COMPILER_BASE/pic32-tools" ]; then
    COMPILER_DIR="$COMPILER_BASE/pic32-tools"
elif [ -d "$COMPILER_BASE/pic32-tools-Linux32" ]; then
    COMPILER_DIR="$COMPILER_BASE/pic32-tools-Linux32"
else
    echo "✗ ERROR: Could not find compiler tools directory"
    MISSING_REQUIRED=true
fi

if [ -n "$COMPILER_DIR" ]; then
    echo "Found compiler directory at: $COMPILER_DIR"
    echo ""
    
    # Check key compiler executables
    check_executable "$COMPILER_DIR/bin/pic32-gcc" "PIC32 GCC Compiler" true
    check_executable "$COMPILER_DIR/bin/pic32-g++" "PIC32 G++ Compiler" true
    check_executable "$COMPILER_DIR/bin/pic32-ar" "PIC32 AR" true
fi

echo "=== Arduino Data Structure ==="
check_path "arduino_data/packages/chipKIT/hardware/pic32/2.1.0" "Arduino core files" true
check_path "arduino_data/packages/chipKIT/tools/pic32-tools/1.43" "Arduino compiler tools" true
check_executable "arduino_data/packages/chipKIT/tools/pic32prog/1.0.0/pic32prog" "PIC32Prog" true

echo "=== Configuration Files ==="
check_path "docker/arduino-cli/arduino-cli.yaml" "Arduino CLI config" true

# Check paths inside the container
echo "=== Container Paths ==="
echo "Checking paths inside arduino-cli container..."
docker compose run --rm --entrypoint=/bin/sh arduino-cli -c '
echo "Compiler tools:";
ls -la /data/packages/chipKIT/tools/pic32-tools/1.43/ 2>/dev/null || echo "Directory not found";
echo "";
echo "Core files:";
ls -la /data/packages/chipKIT/hardware/pic32/2.1.0/ 2>/dev/null || echo "Directory not found";
'

if [ "$MISSING_REQUIRED" = "true" ]; then
    echo "❌ One or more required paths are missing. Please run:"
    echo "   1. ./scripts/thorough-clean.sh"
    echo "   2. docker compose build --no-cache"
    echo "   3. ./scripts/build-core.sh"
    echo "   4. ./scripts/fix-platform.sh"
    exit 1
else
    echo "✅ All required paths are present"
    exit 0
fi