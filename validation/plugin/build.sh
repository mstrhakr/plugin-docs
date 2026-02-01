#!/bin/bash
#
# build.sh - Build the doctest validation plugin
# Part of: https://github.com/mstrhakr/unraid-plugin-docs
#
# Usage: ./build.sh [version]
#   version: Optional version string (default: 2026.02.01)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
DIST_DIR="$SCRIPT_DIR/dist"
SOURCE_DIR="$SCRIPT_DIR/source"
VERSION="${1:-2026.02.01}"
PLUGIN_NAME="doctest"

echo "Building $PLUGIN_NAME version $VERSION"

# Clean previous builds
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$BUILD_DIR" "$DIST_DIR"

# Create package directory structure
mkdir -p "$BUILD_DIR/usr/local/emhttp/plugins/$PLUGIN_NAME"
mkdir -p "$BUILD_DIR/usr/local/emhttp/plugins/$PLUGIN_NAME/event"

# Copy source files
cp -R "$SOURCE_DIR/emhttp/"* "$BUILD_DIR/usr/local/emhttp/plugins/$PLUGIN_NAME/"

# Convert Windows line endings to Unix (in case developed on Windows)
find "$BUILD_DIR" -type f \( -name "*.sh" -o -name "*.page" -o -name "*.cfg" \) -exec sed -i 's/\r$//' {} \;
find "$BUILD_DIR/usr/local/emhttp/plugins/$PLUGIN_NAME/event" -type f -exec sed -i 's/\r$//' {} \;

# Set permissions
find "$BUILD_DIR" -type d -exec chmod 755 {} \;
find "$BUILD_DIR" -type f -exec chmod 644 {} \;
find "$BUILD_DIR" -name "*.sh" -exec chmod 755 {} \;
find "$BUILD_DIR/usr/local/emhttp/plugins/$PLUGIN_NAME/event" -type f -exec chmod 755 {} \;

# Create the TXZ package
cd "$BUILD_DIR"
TXZ_FILE="${PLUGIN_NAME}-${VERSION}.txz"
tar -cJf "$DIST_DIR/$TXZ_FILE" .
echo "Created: $DIST_DIR/$TXZ_FILE"

# Calculate SHA256
cd "$DIST_DIR"
TXZ_SHA256=$(sha256sum "$TXZ_FILE" | cut -d' ' -f1)
echo "SHA256: $TXZ_SHA256"

# Generate PLG file from template
sed -e "s|{{VERSION}}|${VERSION}|g" \
    -e "s|{{TXZ_SHA256}}|${TXZ_SHA256}|g" \
    -e "s|{{TXZ_NAME}}|${TXZ_FILE}|g" \
    "$SCRIPT_DIR/doctest.plg.template" > "$DIST_DIR/${PLUGIN_NAME}.plg"

echo "Created: $DIST_DIR/${PLUGIN_NAME}.plg"

# Copy to validation root for easy access
cp "$DIST_DIR/${PLUGIN_NAME}.plg" "$SCRIPT_DIR/../doctest.plg"

echo ""
echo "Build complete!"
echo "  Package: $DIST_DIR/$TXZ_FILE"
echo "  Plugin:  $DIST_DIR/${PLUGIN_NAME}.plg"
echo ""
echo "To install on an Unraid server:"
echo "  1. Copy $TXZ_FILE and ${PLUGIN_NAME}.plg to the server"
echo "  2. Run: plugin install /path/to/${PLUGIN_NAME}.plg"
