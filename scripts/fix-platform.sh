#!/bin/bash
set -e

# Ensure we're in the project root and get absolute path
cd "$(dirname "$0")/.."
PROJECT_ROOT=$(pwd)

# Wait for the core build to complete if it hasn't already
if [ ! -d "dist/linux32/chipkit-core/pic32" ]; then
    echo "Core not built yet. Building..."
    ./scripts/build-core.sh
fi

# Create a temporary script to run inside the container
cat > tmp/fix-platform.sh <<'EOF'
#!/bin/bash
set -e

echo "Starting platform configuration..."

# Core platform.txt setup
PLATFORM_FILE="/chipkit/dist/linux32/chipkit-core/pic32/platform.txt"
cp "$PLATFORM_FILE" "${PLATFORM_FILE}.backup"
sed -i 's|{runtime.tools.pic32-tools.path}/bin/|{runtime.tools.pic32-tools.path}/bin/|g' "$PLATFORM_FILE"
sed -i 's|{runtime.hardware.path}/tools/bin|{runtime.tools.pic32-tools.path}/bin|g' "$PLATFORM_FILE"

# Setup directories in Arduino data
mkdir -p /data/packages/chipKIT/tools/pic32-tools/1.43/bin
mkdir -p /data/packages/chipKIT/tools/pic32-tools/1.43/lib
mkdir -p /data/packages/chipKIT/tools/pic32-tools/1.43/device_files
mkdir -p /data/packages/chipKIT/tools/pic32prog/1.0.0

# First, organize files in the source directory
TOOLS_DIR="/chipkit/dist/linux32/chipkit-core/pic32/compiler/pic32-tools"
mkdir -p "${TOOLS_DIR}/bin"

# Move all executables to bin directory
cd "${TOOLS_DIR}"
for file in pic32-*; do
    if [ -f "$file" ] && [ -x "$file" ]; then
        echo "Moving $file to bin/"
        mv "$file" "bin/$file"
    fi
done
cd -

# Copy organized files to Arduino data
echo "Copying compiler tools..."
cp -r "${TOOLS_DIR}/bin"/* /data/packages/chipKIT/tools/pic32-tools/1.43/bin/
cp -r "${TOOLS_DIR}/lib" /data/packages/chipKIT/tools/pic32-tools/1.43/
cp -r "${TOOLS_DIR}/device_files" /data/packages/chipKIT/tools/pic32-tools/1.43/

# Copy pic32prog if it exists
if [ -f "/chipkit/dist/linux32/chipkit-core/pic32/tools/bin/pic32prog" ]; then
    echo "Setting up pic32prog..."
    cp "/chipkit/dist/linux32/chipkit-core/pic32/tools/bin/pic32prog" \
        /data/packages/chipKIT/tools/pic32prog/1.0.0/
    chmod +x /data/packages/chipKIT/tools/pic32prog/1.0.0/pic32prog
else
    echo "Warning: pic32prog not found in expected location"
fi

# Make all executables executable
echo "Setting executable permissions..."
find /data/packages/chipKIT/tools/pic32-tools/1.43/bin -type f -exec chmod +x {} \;

echo "Platform configuration completed."
EOF

# Make the temporary script executable
chmod +x tmp/fix-platform.sh

# Run the fix inside the core-builder container with access to arduino data
echo "Running platform fixes in container..."
docker compose run --rm \
    -v "${PROJECT_ROOT}/arduino_data:/data" \
    --entrypoint=/bin/bash \
    core-builder /chipkit/tmp/fix-platform.sh

echo "Platform configuration completed successfully."