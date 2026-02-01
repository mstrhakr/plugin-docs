---
layout: default
title: Event Types Reference
parent: Reference
nav_order: 3
---

# Event Types Reference

## Overview

This reference documents all available event hooks in Unraid that plugins can respond to. Events are scripts placed in your plugin's `event/` directory.

## Event Basics

Events are shell scripts that run when specific system actions occur:

```
/usr/local/emhttp/plugins/yourplugin/event/
└── event_name              # Script runs when event fires
```

Script requirements:
- Must be executable (`chmod 755`)
- Should complete quickly (they block the triggering action)
- No file extension needed

## Execution Context

### Environment

Event scripts run with:
- **User**: `root`
- **Working directory**: `/`
- **PATH**: Standard system path
- **Shell**: `/bin/bash` (use shebang to ensure)

### Available Environment Variables

```bash
#!/bin/bash
# These are typically available in event scripts

# Passed by some events as arguments
$1, $2, etc.    # Event-specific arguments

# Standard environment
$HOME           # /root
$PATH           # System path
$USER           # root
```

## Array Events

### starting_array

Triggered when the array begins starting (before disks are mounted).

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/starting_array
logger -t "yourplugin" "Array is starting"

# Use cases:
# - Prepare resources before array is available
# - Check prerequisites
# - Clean up stale state from previous run
```

**Timing**: Before disk mounts  
**Blocking**: Yes - array start waits  
**Arguments**: None

### started_array

Triggered after array is fully started and all disks are mounted.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/started_array
logger -t "yourplugin" "Array started, starting service"

# Start services that need array access
/etc/rc.d/rc.yourplugin start

# Create working directories on array
mkdir -p /mnt/user/appdata/yourplugin
```

**Timing**: After all mounts complete  
**Blocking**: Yes  
**Arguments**: None

### stopping_array

Triggered when array begins stopping (before disks are unmounted).

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopping_array
logger -t "yourplugin" "Array stopping, stopping service"

# Stop services that use array
/etc/rc.d/rc.yourplugin stop

# Save state before unmount
cp /var/run/yourplugin/state /boot/config/plugins/yourplugin/
```

**Timing**: Before unmounts  
**Blocking**: Yes - disks wait  
**Arguments**: None

### stopped_array

Triggered after array is fully stopped and all disks are unmounted.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopped_array
logger -t "yourplugin" "Array fully stopped"

# Clean up any remaining processes
killall yourplugin_worker 2>/dev/null
```

**Timing**: After all unmounts  
**Blocking**: Yes  
**Arguments**: None

## Docker Events

### docker_started

Triggered when Docker service starts and is ready.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/docker_started
logger -t "yourplugin" "Docker is now available"

# Start containers managed by your plugin
docker start mycontainer 2>/dev/null

# Or trigger container-dependent setup
/usr/local/emhttp/plugins/yourplugin/scripts/docker-setup.sh &
```

**Timing**: After Docker daemon ready  
**Blocking**: Yes  
**Arguments**: None

### docker_stopped

Triggered when Docker service stops.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/docker_stopped
logger -t "yourplugin" "Docker stopped"

# Handle docker-dependent resources
```

**Timing**: After Docker daemon stops  
**Blocking**: Yes  
**Arguments**: None

## Disk Events

### unmounting_disk

Triggered before a specific disk is unmounted.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/unmounting_disk

DISK="$1"  # Disk being unmounted (e.g., "disk1", "cache")

logger -t "yourplugin" "Disk $DISK being unmounted"

# Stop any processes using this disk
if [ "$DISK" == "cache" ]; then
    /etc/rc.d/rc.yourplugin stop
fi
```

**Timing**: Before unmount  
**Blocking**: Yes  
**Arguments**: `$1` = disk name (disk1, disk2, cache, etc.)

### disks_mounted

Triggered after disks are mounted during array start.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/disks_mounted
logger -t "yourplugin" "Disks mounted"
```

**Timing**: After mounts  
**Blocking**: Yes  
**Arguments**: None

## VM Events

### libvirt_started

Triggered when libvirt/VM service starts.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/libvirt_started
logger -t "yourplugin" "libvirt started, VMs available"

# Interact with VMs
virsh list --all
```

**Timing**: After libvirt ready  
**Blocking**: Yes  
**Arguments**: None

### libvirt_stopped

Triggered when libvirt/VM service stops.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/libvirt_stopped
logger -t "yourplugin" "libvirt stopped"
```

**Timing**: After libvirt stops  
**Blocking**: Yes  
**Arguments**: None

## Network Events

### network_ready

Triggered when network is configured and ready.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/network_ready
logger -t "yourplugin" "Network ready"

# Start network-dependent services
/etc/rc.d/rc.yourplugin start
```

**Timing**: After network configuration  
**Blocking**: Yes  
**Arguments**: None

## System Events

### reboot

Triggered before system reboot.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/reboot
logger -t "yourplugin" "System rebooting, saving state"

# Save state before reboot
/etc/rc.d/rc.yourplugin stop
cp /var/run/yourplugin/data /boot/config/plugins/yourplugin/
```

**Timing**: Before reboot  
**Blocking**: Yes  
**Arguments**: None

### shutdown

Triggered before system shutdown.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/shutdown
logger -t "yourplugin" "System shutting down"

# Clean shutdown
/etc/rc.d/rc.yourplugin stop
```

**Timing**: Before shutdown  
**Blocking**: Yes  
**Arguments**: None

## Parity Events

### parity_check_started

Triggered when a parity check/sync begins.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/parity_check_started
ACTION="$1"  # "check", "sync", "repair"

logger -t "yourplugin" "Parity $ACTION started"

# Notify user
/usr/local/emhttp/webGui/scripts/notify \
    -e "Parity" \
    -s "Parity $ACTION Started" \
    -d "A parity $ACTION has begun" \
    -i "normal"
```

**Timing**: When parity operation starts  
**Blocking**: No (runs in background)  
**Arguments**: `$1` = action type (check, sync, repair)

### parity_check_finished

Triggered when a parity check/sync completes.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/parity_check_finished
ACTION="$1"      # "check", "sync", "repair"
RESULT="$2"      # Exit code
ERRORS="$3"      # Error count

logger -t "yourplugin" "Parity $ACTION finished: $ERRORS errors"

# Notify based on result
if [ "$ERRORS" -gt 0 ]; then
    /usr/local/emhttp/webGui/scripts/notify \
        -e "Parity" \
        -s "Parity $ACTION Completed with Errors" \
        -d "Parity $ACTION found $ERRORS errors" \
        -i "warning"
fi
```

**Timing**: When parity operation completes  
**Blocking**: No  
**Arguments**: `$1` = action, `$2` = result code, `$3` = error count

## User Share Events

### user_share_created

Triggered when a user share is created.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/user_share_created
SHARE="$1"

logger -t "yourplugin" "Share '$SHARE' created"
```

**Arguments**: `$1` = share name

### user_share_deleted

Triggered when a user share is deleted.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/user_share_deleted
SHARE="$1"

logger -t "yourplugin" "Share '$SHARE' deleted"
```

**Arguments**: `$1` = share name

## Complete Event Table

| Event | Trigger | Blocking | Arguments |
|-------|---------|----------|-----------|
| `starting_array` | Array start begins | Yes | None |
| `started_array` | Array fully started | Yes | None |
| `stopping_array` | Array stop begins | Yes | None |
| `stopped_array` | Array fully stopped | Yes | None |
| `docker_started` | Docker service up | Yes | None |
| `docker_stopped` | Docker service down | Yes | None |
| `libvirt_started` | VM service up | Yes | None |
| `libvirt_stopped` | VM service down | Yes | None |
| `network_ready` | Network configured | Yes | None |
| `unmounting_disk` | Before disk unmount | Yes | `$1`=disk |
| `disks_mounted` | After disk mounts | Yes | None |
| `reboot` | Before reboot | Yes | None |
| `shutdown` | Before shutdown | Yes | None |
| `parity_check_started` | Parity op starts | No | `$1`=action |
| `parity_check_finished` | Parity op ends | No | `$1`=action, `$2`=result, `$3`=errors |
| `user_share_created` | Share created | Yes | `$1`=name |
| `user_share_deleted` | Share deleted | Yes | `$1`=name |

## Event Script Template

```bash
#!/bin/bash
#
# Event: [event_name]
# Description: [what this event responds to]
# Arguments: [list any arguments]
#

PLUGIN="yourplugin"

# Log the event
logger -t "$PLUGIN" "Event [event_name] triggered"

# Access arguments if provided
ARG1="${1:-}"
ARG2="${2:-}"

# Your event handling code here

# For long operations, background them
long_running_task &

# Exit cleanly
exit 0
```

## Best Practices

1. **Keep it fast** - Events block other operations; long tasks should be backgrounded
2. **Background long tasks** - Use `&` for anything that takes more than a few seconds
3. **Log appropriately** - Record what happened for debugging
4. **Handle errors gracefully** - Don't crash on failure; log and continue
5. **Be idempotent** - Handle being called multiple times safely
6. **Check prerequisites** - Verify required resources exist before acting
7. **Use proper shebang** - Always start with `#!/bin/bash`

## Debugging Events

### Test manually
```bash
# Run your event script directly
/usr/local/emhttp/plugins/yourplugin/event/started_array

# Check exit code
echo $?
```

### Watch syslog
```bash
# Monitor for your plugin's events
tail -f /var/log/syslog | grep yourplugin
```

### Add debug logging
```bash
#!/bin/bash
set -x  # Enable debug output
exec 2>&1 | logger -t "yourplugin-debug"

# Your script here
```

## Related Topics

- [Event System](../events.md)
- [rc.d Scripts](../core/rc-d-scripts.md)
- [Cron Jobs](../core/cron-jobs.md)
