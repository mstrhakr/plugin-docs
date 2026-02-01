#!/bin/bash
#
# validate-all.sh - Run all documentation validation scripts
# Part of: https://github.com/mstrhakr/unraid-plugin-docs
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION=$(grep 'version=' /etc/unraid-version | cut -d'"' -f2)

echo "=============================================="
echo "Unraid Plugin Documentation Validation Suite"
echo "=============================================="
echo ""
echo "Unraid Version: $VERSION"
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Hostname: $(hostname)"
echo ""

# Run each validation script
echo "=== Event System Validation ==="
bash "$SCRIPT_DIR/validate-events.sh"
echo ""

echo "=== File Path Validation ==="
bash "$SCRIPT_DIR/validate-paths.sh"
echo ""

echo "=== \$var Array Validation ==="
bash "$SCRIPT_DIR/validate-vars.sh"
echo ""

echo "=== PHP Functions Validation ==="
bash "$SCRIPT_DIR/validate-php.sh"
echo ""

echo "=============================================="
echo "Validation Complete"
echo "=============================================="
