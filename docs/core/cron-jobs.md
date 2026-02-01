---
layout: default
title: Cron Jobs
parent: Core Concepts
nav_order: 7
---

# Cron Jobs

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Plugins can add scheduled tasks using cron. Unraid uses the standard cron daemon with files in `/etc/cron.d/`.

## Adding a Cron Job

Cron files should be installed to `/etc/cron.d/` since this directory is in RAM and recreated on boot.

### Via PLG File

```xml
<FILE Name="/etc/cron.d/yourplugin">
<INLINE>
# Run every hour
0 * * * * root /usr/local/emhttp/plugins/yourplugin/scripts/hourly.sh &gt;/dev/null 2&gt;&amp;1
</INLINE>
</FILE>
```

### Via rc.d Script

```bash
#!/bin/bash
# /etc/rc.d/rc.yourplugin

case "$1" in
  'start')
    # Create cron job
    echo "*/5 * * * * root /usr/local/emhttp/plugins/yourplugin/check.sh" > /etc/cron.d/yourplugin
    ;;
  'stop')
    # Remove cron job
    rm -f /etc/cron.d/yourplugin
    ;;
esac
```

## Cron Syntax Reference

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6) (Sunday = 0)
│ │ │ │ │
* * * * * user command
```

## Common Patterns

| Pattern | Description |
|---------|-------------|
| `0 * * * *` | Every hour |
| `*/5 * * * *` | Every 5 minutes |
| `0 0 * * *` | Daily at midnight |
| `0 3 * * 0` | Weekly on Sunday at 3 AM |
| `0 0 1 * *` | Monthly on the 1st |

## User Context

Always specify the user (typically `root`) in `/etc/cron.d/` files:

```
* * * * * root /path/to/script.sh
```

## Logging Output

```bash
# Discard output (silent)
0 * * * * root /script.sh >/dev/null 2>&1

# Log to file
0 * * * * root /script.sh >> /var/log/yourplugin.log 2>&1

# Log to syslog
0 * * * * root /script.sh 2>&1 | logger -t yourplugin
```

## Persistence

Remember that `/etc/cron.d/` is in RAM. Your cron jobs must be recreated:
- On boot (via PLG FILE element or rc.d script)
- After array start if they depend on array

## Related Topics

- [PLG File Reference]({% link docs/plg-file.md %})
- [rc.d Scripts]({% link docs/core/rc-d-scripts.md %})
- [Event System]({% link docs/events.md %})
