#!/bin/bash
#
# validate-vars.sh - Validate documented $var array properties
# Part of: https://github.com/mstrhakr/unraid-plugin-docs
#

VAR_INI="/var/local/emhttp/var.ini"

echo "Validating \$var array properties from $VAR_INI:"
echo ""

if [ ! -f "$VAR_INI" ]; then
    echo "❌ FAIL: var.ini not found at $VAR_INI"
    exit 1
fi

# Properties documented in var-array-reference.md
DOCUMENTED_VARS=(
    # System Identity
    "NAME"
    "COMMENT"
    "localMaster"
    "timeZone"
    "USE_NTP"
    "NTP_SERVER1"
    "NTP_SERVER2"
    
    # Unraid Version
    "version"
    "regTy"
    "regTo"
    "regTm"
    "flashGUID"
    
    # Array State
    "fsState"
    "mdState"
    "mdResync"
    "mdResyncSize"
    "mdResyncAction"
    "mdNumStripes"
    "mdNumDisks"
    "mdNumDisabled"
    "mdNumMissing"
    "mdNumInvalid"
    "mdNumNew"
    
    # Security
    "csrf_token"
    "USE_SSL"
    "PORT"
    "PORTSSL"
    
    # Network
    "USE_TELNET"
    "USE_SSH"
    "LOCAL_TLD"
    
    # Spin Settings
    "spindownDelay"
    "spinupGroups"
)

PASS=0
FAIL=0

for var in "${DOCUMENTED_VARS[@]}"; do
    # Check if the variable exists in var.ini (case-insensitive key match)
    if grep -qi "^${var}=" "$VAR_INI"; then
        value=$(grep -i "^${var}=" "$VAR_INI" | head -1 | cut -d'"' -f2)
        # Truncate long values
        if [ ${#value} -gt 40 ]; then
            value="${value:0:40}..."
        fi
        echo "  ✅ $var = \"$value\""
        ((PASS++))
    else
        echo "  ❌ $var - NOT FOUND"
        ((FAIL++))
    fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"

echo ""
echo "Additional properties found in var.ini (not documented):"
grep "^[A-Za-z]" "$VAR_INI" | cut -d'=' -f1 | while read prop; do
    # Check if it's in our documented list
    found=0
    for doc in "${DOCUMENTED_VARS[@]}"; do
        if [ "${prop,,}" == "${doc,,}" ]; then
            found=1
            break
        fi
    done
    if [ $found -eq 0 ]; then
        echo "  - $prop"
    fi
done | head -20
echo "  (showing first 20 undocumented properties)"
