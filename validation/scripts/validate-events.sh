#!/bin/bash
#
# validate-events.sh - Validate documented event names exist
# Part of: https://github.com/mstrhakr/plugin-docs
#

EMHTTP_EVENT="/usr/local/sbin/emhttp_event"

# Events documented in the documentation
DOCUMENTED_EVENTS=(
    "driver_loaded"
    "starting"
    "array_started"
    "disks_mounted"
    "svcs_restarted"
    "docker_started"
    "libvirt_started"
    "started"
    "stopping"
    "stopping_libvirt"
    "stopping_docker"
    "stopping_svcs"
    "unmounting_disks"
    "stopping_array"
    "stopped"
    "poll_attributes"
)

echo "Checking emhttp_event script: $EMHTTP_EVENT"
echo ""

if [ ! -f "$EMHTTP_EVENT" ]; then
    echo "❌ FAIL: emhttp_event script not found at $EMHTTP_EVENT"
    exit 1
fi

echo "✅ emhttp_event script exists"
echo ""
echo "Validating documented events:"
echo ""

PASS=0
FAIL=0

for event in "${DOCUMENTED_EVENTS[@]}"; do
    if grep -q "^# $event$" "$EMHTTP_EVENT"; then
        echo "  ✅ $event"
        ((PASS++))
    else
        echo "  ❌ $event - NOT FOUND in emhttp_event"
        ((FAIL++))
    fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"

# Also show any events in emhttp_event that we might have missed
echo ""
echo "Events found in emhttp_event (for comparison):"
grep -oP '(?<=^# )[a-z_]+$' "$EMHTTP_EVENT" | while read event; do
    echo "  - $event"
done
