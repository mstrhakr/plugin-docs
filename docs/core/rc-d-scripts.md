---
layout: default
title: rc.d Scripts
parent: Core Concepts
nav_order: 8
---

# rc.d Scripts

{: .note }
> ✅ **Validated against Unraid 7.2.3** - Script location `/etc/rc.d/` and structure verified.

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

rc.d scripts manage services in Unraid. They handle starting, stopping, and restarting daemons and provide a standardized interface for service control.

## Script Location

rc.d scripts are installed to the standard Linux location for service control scripts. Since this directory is in RAM, your PLG file must install the script on each boot.

```
/etc/rc.d/rc.yourplugin
```

This location is in RAM, so scripts must be installed via your PLG file.

## Basic Structure

A standard rc.d script implements `start`, `stop`, `restart`, and `status` commands using a case statement. The script tracks service state with a PID file. This pattern matches Linux conventions and integrates with Unraid's service management.

```bash
#!/bin/bash
#
# rc.yourplugin - Service control script for Your Plugin
#

DAEMON="/usr/local/emhttp/plugins/yourplugin/daemon"
PIDFILE="/var/run/yourplugin.pid"

start() {
    if [ -f "$PIDFILE" ]; then
        echo "Service already running"
        return 1
    fi
    echo "Starting Your Plugin..."
    $DAEMON &
    echo $! > "$PIDFILE"
}

stop() {
    if [ ! -f "$PIDFILE" ]; then
        echo "Service not running"
        return 1
    fi
    echo "Stopping Your Plugin..."
    kill $(cat "$PIDFILE") 2>/dev/null
    rm -f "$PIDFILE"
}

restart() {
    stop
    sleep 1
    start
}

status() {
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
        echo "Running"
    else
        echo "Stopped"
    fi
}

case "$1" in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    'restart')
        restart
        ;;
    'status')
        status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
```

## Auto-Start on Boot

### Via PLG FILE Element

```xml
<FILE Run="/bin/bash" Method="install">
<INLINE>
# Start the service
/etc/rc.d/rc.yourplugin start
</INLINE>
</FILE>
```

### Via Array Start Event

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/starting_array
/etc/rc.d/rc.yourplugin start
```

## Stopping on Shutdown

Unraid calls stop scripts automatically during shutdown. Ensure your script handles the `stop` case properly.

## Service Dependencies

If your service depends on the array being started:

```bash
start() {
    # Check if array is started
    if [ ! -d "/mnt/user" ]; then
        echo "Array not started, cannot start service"
        return 1
    fi
    # ... start service
}
```

## Web UI Integration

Provide status and control from your plugin's page:

```php
<?
// Check service status
exec("/etc/rc.d/rc.yourplugin status", $output, $retval);
$running = (strpos(implode($output), "Running") !== false);
?>

<form method="POST">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    <?if ($running):?>
        <input type="submit" name="action" value="Stop">
        <input type="submit" name="action" value="Restart">
    <?else:?>
        <input type="submit" name="action" value="Start">
    <?endif;?>
</form>
```

## Best Practices

- Always use a PID file to track running processes
- Handle graceful shutdown with proper signal handling
- Check dependencies before starting
- Provide meaningful status output
- Log important events

## Related Topics

- [PLG File Reference]({% link docs/plg-file.md %})
- [Event System]({% link docs/events.md %})
- [Cron Jobs]({% link docs/core/cron-jobs.md %})
