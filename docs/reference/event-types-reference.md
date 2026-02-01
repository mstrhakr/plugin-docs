---
layout: default
title: Event Types Reference
parent: Reference
nav_order: 3
---

# Event Types Reference

{: .note }
> ✅ **Validated against Unraid 7.2.3** - Event names verified against `/usr/local/sbin/emhttp_event`.

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
$1, $2, etc.    # Event-specific arguments (usually the event name)

# Standard environment
$HOME           # /root
$PATH           # System path
$USER           # root
```

## Startup Events

These events fire during array startup, in the order listed.

### driver_loaded

Triggered early in emhttp initialization when INI files are valid.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/driver_loaded
logger -t "yourplugin" "Driver loaded, status info valid"

# Use cases:
# - Load kernel modules
# - Early initialization
```

**Timing**: Early initialization  
**Blocking**: Yes  
**Arguments**: `$1` = "driver_loaded"

### starting

Triggered at the beginning of cmdStart execution (array start begins).

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/starting
logger -t "yourplugin" "Array is starting"

# Use cases:
# - Prepare resources before array is available
# - Check prerequisites
# - Clean up stale state from previous run
```

**Timing**: Beginning of array start  
**Blocking**: Yes - array start waits  
**Arguments**: `$1` = "starting"

### array_started

Triggered during cmdStart when the MD devices (`/dev/md*`) become valid.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/array_started
logger -t "yourplugin" "Array devices are valid"

# Use cases:
# - Access raw MD devices
# - Low-level array operations
```

**Timing**: After MD devices are valid, before mounts  
**Blocking**: Yes  
**Arguments**: `$1` = "array_started"

### disks_mounted

Triggered when disks and user shares (if enabled) are mounted.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/disks_mounted
logger -t "yourplugin" "Disks and user shares mounted"

# Use cases:
# - Access /mnt/user/ and /mnt/disk*
# - Create directories on array
mkdir -p /mnt/user/appdata/yourplugin
```

**Timing**: After mounts complete  
**Blocking**: Yes  
**Arguments**: `$1` = "disks_mounted"

### svcs_restarted

Triggered when network services are started or restarted (also fires on share changes).

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/svcs_restarted
logger -t "yourplugin" "Network services restarted"

# Use cases:
# - Configure network-dependent services
# - React to share configuration changes
```

**Timing**: After network services start  
**Blocking**: Yes  
**Arguments**: `$1` = "svcs_restarted"

### docker_started

Triggered when Docker service is enabled and started.

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
**Arguments**: `$1` = "docker_started"

### libvirt_started

Triggered when libvirt/VM service is enabled and started.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/libvirt_started
logger -t "yourplugin" "libvirt started, VMs available"

# Interact with VMs
virsh list --all
```

**Timing**: After libvirt ready  
**Blocking**: Yes  
**Arguments**: `$1` = "libvirt_started"

### started

Triggered at the end of cmdStart execution (array start complete).

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/started
logger -t "yourplugin" "Array fully started, initializing..."

# Start services that need full array access
/etc/rc.d/rc.yourplugin start

# For long-running tasks, background them
/usr/local/emhttp/plugins/yourplugin/scripts/background_task.sh &

logger -t "yourplugin" "Initialization complete"
```

**Timing**: End of array start sequence  
**Blocking**: Yes  
**Arguments**: `$1` = "started"

## Shutdown Events

These events fire during array shutdown, in the order listed.

### stopping

Triggered at the beginning of cmdStop execution (array stop begins).

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopping
logger -t "yourplugin" "Array stopping"

# Use cases:
# - Pre-shutdown preparation
# - Alert dependent processes
```

**Timing**: Beginning of array stop  
**Blocking**: Yes  
**Arguments**: `$1` = "stopping"

### stopping_libvirt

Triggered during cmdStop, about to stop libvirt.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopping_libvirt
logger -t "yourplugin" "About to stop libvirt"

# Use cases:
# - Gracefully stop VMs managed by your plugin
# - Save VM state
```

**Timing**: Before libvirt stops  
**Blocking**: Yes  
**Arguments**: `$1` = "stopping_libvirt"

### stopping_docker

Triggered during cmdStop, about to stop Docker.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopping_docker
logger -t "yourplugin" "About to stop Docker"

# Stop containers managed by your plugin
docker stop mycontainer 2>/dev/null
```

**Timing**: Before Docker stops  
**Blocking**: Yes  
**Arguments**: `$1` = "stopping_docker"

### stopping_svcs

Triggered during cmdStop, about to stop network services.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopping_svcs
logger -t "yourplugin" "About to stop network services"

# Use cases:
# - Cleanup network resources
# - Disconnect clients gracefully
```

**Timing**: Before network services stop  
**Blocking**: Yes  
**Arguments**: `$1` = "stopping_svcs"

### unmounting_disks

Triggered during cmdStop when disks are about to be unmounted. At this point, disks have been spun up and a "sync" has been executed.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/unmounting_disks
logger -t "yourplugin" "Disks about to unmount"

# Use cases:
# - Final disk access before unmount
# - Save state from array to flash
cp /mnt/user/appdata/yourplugin/state /boot/config/plugins/yourplugin/
```

**Timing**: Before unmounts, after sync  
**Blocking**: Yes  
**Arguments**: `$1` = "unmounting_disks"

### stopping_array

Triggered during cmdStop after disks and user shares have been unmounted, about to stop the array.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopping_array
logger -t "yourplugin" "Array stopping, disks unmounted"

# Stop services that were using the array
/etc/rc.d/rc.yourplugin stop
```

**Timing**: After unmounts, before array stop  
**Blocking**: Yes  
**Arguments**: `$1` = "stopping_array"

### stopped

Triggered at the end of cmdStop execution (array fully stopped), or if cmdStart failed.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopped
logger -t "yourplugin" "Array fully stopped"

# Clean up any remaining processes
killall yourplugin_worker 2>/dev/null
```

**Timing**: End of array stop sequence  
**Blocking**: Yes  
**Arguments**: `$1` = "stopped"

## Other Events

### poll_attributes

Triggered after each time emhttp polls disk SMART data. Note that if the array is not started, emhttp will still poll SMART data for spun-up devices and generate this event.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/poll_attributes
logger -t "yourplugin" "SMART data polled"

# Use cases:
# - Monitor disk health
# - Custom SMART alerting
```

**Timing**: After SMART polling  
**Blocking**: Yes  
**Arguments**: `$1` = "poll_attributes"

## Complete Event Table

| Event | Trigger | Blocking | Phase |
|-------|---------|----------|-------|
| `driver_loaded` | Early init, INI files valid | Yes | Startup |
| `starting` | Array start begins | Yes | Startup |
| `array_started` | MD devices valid | Yes | Startup |
| `disks_mounted` | Disks and shares mounted | Yes | Startup |
| `svcs_restarted` | Network services started | Yes | Startup |
| `docker_started` | Docker service up | Yes | Startup |
| `libvirt_started` | VM service up | Yes | Startup |
| `started` | Array start complete | Yes | Startup |
| `stopping` | Array stop begins | Yes | Shutdown |
| `stopping_libvirt` | About to stop VMs | Yes | Shutdown |
| `stopping_docker` | About to stop Docker | Yes | Shutdown |
| `stopping_svcs` | About to stop network | Yes | Shutdown |
| `unmounting_disks` | Disks about to unmount | Yes | Shutdown |
| `stopping_array` | Disks unmounted | Yes | Shutdown |
| `stopped` | Array fully stopped | Yes | Shutdown |
| `poll_attributes` | SMART data polled | Yes | Periodic |

## Event Script Template

```bash
#!/bin/bash
#
# Event: [event_name]
# Description: [what this event responds to]
#

PLUGIN="yourplugin"
EVENT="${1:-unknown}"

# Log the event
logger -t "$PLUGIN" "Event $EVENT triggered"

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
# Run your event script directly with the event name argument
/usr/local/emhttp/plugins/yourplugin/event/started started

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
