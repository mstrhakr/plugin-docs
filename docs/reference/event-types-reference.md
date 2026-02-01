---
layout: default
title: Event Types Reference
parent: Reference
nav_order: 3
---

# Event Types Reference

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

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

## Array Events

### starting_array

Triggered when the array begins starting.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/starting_array
logger -t "yourplugin" "Array is starting"
```

**Use cases:**
- Prepare resources before array is available
- Check prerequisites

### started_array

Triggered after array is fully started and mounted.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/started_array
logger -t "yourplugin" "Array started, starting service"
/etc/rc.d/rc.yourplugin start
```

**Use cases:**
- Start services that need array access
- Initialize data on shares

### stopping_array

Triggered when array begins stopping.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopping_array
logger -t "yourplugin" "Array stopping, stopping service"
/etc/rc.d/rc.yourplugin stop
```

**Use cases:**
- Stop services that use array
- Save state before unmount

### stopped_array

Triggered after array is fully stopped.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/stopped_array
logger -t "yourplugin" "Array fully stopped"
```

**Use cases:**
- Cleanup after array stops

## Docker Events

### docker_started

Triggered when Docker service starts.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/docker_started
logger -t "yourplugin" "Docker is now available"
```

### docker_stopped

Triggered when Docker service stops.

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/docker_stopped
logger -t "yourplugin" "Docker stopped"
```

## Disk Events

TODO: Document disk-related events

### disk_added

```bash
#!/bin/bash
# Triggered when a new disk is added
# $1 = disk identifier (?)
```

### disk_removed

```bash
#!/bin/bash
# Triggered when a disk is removed
```

### unmounting_disk

```bash
#!/bin/bash
# Triggered before disk unmount
```

## Network Events

TODO: Document network events

### network_ready

```bash
#!/bin/bash
# Triggered when network is configured
```

## VM Events

TODO: Document VM/libvirt events

### libvirt_started

```bash
#!/bin/bash
# Triggered when libvirt/VM service starts
```

## System Events

TODO: Document additional system events

### reboot

```bash
#!/bin/bash
# Triggered before system reboot
```

### shutdown

```bash
#!/bin/bash
# Triggered before system shutdown
```

## Parity Events

TODO: Document parity check events

### parity_check_started

```bash
#!/bin/bash
# Triggered when parity check begins
```

### parity_check_finished

```bash
#!/bin/bash
# Triggered when parity check completes
```

## Complete Event List

TODO: Complete this table with all events

| Event | When Triggered | Arguments |
|-------|----------------|-----------|
| `starting_array` | Array start begins | None |
| `started_array` | Array fully started | None |
| `stopping_array` | Array stop begins | None |
| `stopped_array` | Array fully stopped | None |
| `docker_started` | Docker service up | None |
| `docker_stopped` | Docker service down | None |
| `libvirt_started` | VM service up | None |
| `libvirt_stopped` | VM service down | None |
| `unmounting_disk` | Before disk unmount | TBD |
| `disk_added` | Disk added | TBD |
| `disk_removed` | Disk removed | TBD |
| `parity_check_started` | Parity check begins | TBD |
| `parity_check_finished` | Parity check ends | TBD |

## Event Arguments

Some events pass arguments to scripts:

```bash
#!/bin/bash
# Access arguments
EVENT_TYPE=$1
EVENT_DATA=$2

logger -t "yourplugin" "Event: $EVENT_TYPE, Data: $EVENT_DATA"
```

TODO: Document which events pass what arguments

## Event Script Template

```bash
#!/bin/bash
#
# Event: [event_name]
# Description: [what this event responds to]
#

PLUGIN="yourplugin"

# Log the event
logger -t "$PLUGIN" "Event [event_name] triggered"

# Your event handling code here

# Exit cleanly
exit 0
```

## Best Practices

1. **Keep it fast** - Events block other operations
2. **Background long tasks** - Use `&` for lengthy operations
3. **Log appropriately** - Record what happened
4. **Handle errors** - Don't crash on failure
5. **Be idempotent** - Handle being called multiple times

## Debugging Events

```bash
# Test event script manually
/usr/local/emhttp/plugins/yourplugin/event/started_array

# Watch syslog for event triggers
tail -f /var/log/syslog | grep yourplugin
```

## Related Topics

- [Event System]({% link docs/events.md %})
- [rc.d Scripts]({% link docs/core/rc-d-scripts.md %})
- [Cron Jobs]({% link docs/core/cron-jobs.md %})
