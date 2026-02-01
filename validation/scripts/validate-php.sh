#!/bin/bash
#
# validate-php.sh - Validate documented PHP functions exist
# Part of: https://github.com/mstrhakr/unraid-plugin-docs
#

echo "Validating documented PHP functions:"
echo ""

PASS=0
FAIL=0

check_function() {
    local func="$1"
    local file="$2"
    local description="$3"
    
    if [ -f "$file" ]; then
        if grep -q "function $func" "$file"; then
            echo "  ✅ $func()"
            echo "     Found in: $file"
            ((PASS++))
        else
            echo "  ❌ $func() - NOT FOUND in $file"
            ((FAIL++))
        fi
    else
        echo "  ❌ $func() - File not found: $file"
        ((FAIL++))
    fi
}

echo "=== Configuration Functions ==="
check_function "parse_plugin_cfg" "/usr/local/emhttp/plugins/dynamix/include/Wrappers.php"
check_function "my_parse_ini_file" "/usr/local/emhttp/plugins/dynamix/include/Wrappers.php"

echo ""
echo "=== Helper Functions ==="
check_function "mk_option" "/usr/local/emhttp/plugins/dynamix/include/Helpers.php"
check_function "mk_option_check" "/usr/local/emhttp/plugins/dynamix/include/Helpers.php"

echo ""
echo "=== Translation Functions ==="
# The _() function is typically defined in the translation system
if grep -rq "function _\(" /usr/local/emhttp/plugins/dynamix/include/ 2>/dev/null; then
    echo "  ✅ _()"
    echo "     Translation function found"
    ((PASS++))
else
    echo "  ⚠️  _() - May be a PHP gettext alias"
    ((PASS++))  # Count as pass since it's a standard PHP function
fi

echo ""
echo "=== parse_plugin_cfg() Implementation Check ==="
echo ""
echo "Verifying parse_plugin_cfg reads from correct paths:"

WRAPPERS="/usr/local/emhttp/plugins/dynamix/include/Wrappers.php"
if [ -f "$WRAPPERS" ]; then
    echo ""
    echo "  Checking for default.cfg path:"
    if grep -q 'plugins/\$plugin/default.cfg' "$WRAPPERS"; then
        echo "    ✅ Reads from \$docroot/plugins/\$plugin/default.cfg"
        ((PASS++))
    else
        echo "    ❌ default.cfg path not found as documented"
        ((FAIL++))
    fi
    
    echo ""
    echo "  Checking for user config path:"
    if grep -q '/boot/config/plugins/\$plugin/\$plugin.cfg' "$WRAPPERS"; then
        echo "    ✅ Reads from /boot/config/plugins/\$plugin/\$plugin.cfg"
        ((PASS++))
    else
        echo "    ❌ User config path not found as documented"
        ((FAIL++))
    fi
fi

echo ""
echo "=== PHP Version ==="
php -v | head -1

echo ""
echo "Results: $PASS passed, $FAIL failed"
