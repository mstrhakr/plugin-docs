---
layout: default
title: Cron Jobs
parent: Core Concepts
nav_order: 7
---

# Cron Jobs

## Overview

Plugins can add scheduled tasks using cron. Unraid uses the standard cron daemon with files in `/etc/cron.d/`. Additionally, Unraid provides a built-in **Dynamix Scheduler** that offers a GUI-based interface for managing scheduled tasks.

## Methods for Scheduling Tasks

There are three primary ways to schedule tasks in Unraid:

| Method | Best For | Persistence |
|--------|----------|-------------|
| `/etc/cron.d/` files | System-level tasks | Recreate on boot |
| Dynamix Scheduler | User-configurable tasks | Automatic via GUI |
| User Scripts plugin | User-defined scripts | Via plugin settings |

## Adding a Cron Job via /etc/cron.d/

Cron files should be installed to `/etc/cron.d/` since this directory is in RAM and recreated on boot.

### Via PLG File

Install cron jobs directly from your PLG file using a `<FILE>` element. Note the XML entity encoding: `&gt;` for `>` and `&amp;` for `&`. The job runs as root and redirects output to prevent cron email spam.

```xml
<FILE Name="/etc/cron.d/yourplugin">
<INLINE>
# Run every hour
0 * * * * root /usr/local/emhttp/plugins/yourplugin/scripts/hourly.sh &gt;/dev/null 2&gt;&amp;1
</INLINE>
</FILE>
```

### Via rc.d Script

For dynamic schedules or conditional cron jobs, create/remove the cron file from an rc.d script. This allows enabling/disabling scheduled tasks based on plugin settings without modifying the PLG file.

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

## Dynamix Scheduler Integration

The Dynamix Scheduler provides a GUI for scheduling tasks at Settings → Scheduler. Plugins can integrate with this system to let users configure schedules without editing cron files manually.

### Scheduler Configuration File

The Dynamix Scheduler reads from `/boot/config/plugins/dynamix/dynamix.cfg`:

```ini
# Example scheduler entries in dynamix.cfg
parity="0|0|*|*|*"        # Parity check schedule
mover="0|3|*|*|*"         # Mover schedule
```

### Adding Plugin Tasks to the Scheduler

To integrate with the Dynamix Scheduler, your plugin can add entries to the scheduler page:

```php
<?
// In your settings page, provide scheduler controls
$cfg = parse_plugin_cfg("yourplugin");

// Default schedule: disabled
$schedule = $cfg['schedule'] ?? '';

// Parse cron schedule into components
if ($schedule) {
    list($min, $hour, $dom, $mon, $dow) = explode(' ', $schedule);
} else {
    $min = $hour = $dom = $mon = $dow = '*';
}
?>
```

### Scheduler UI Controls

Use the standard Dynamix scheduler dropdown pattern:

```html
<dl>
    <dt>Schedule:</dt>
    <dd>
        <select name="schedule_type" onchange="toggleSchedule(this.value)">
            <option value="disabled" <?=($cfg['schedule_type']=='disabled')?'selected':''?>>Disabled</option>
            <option value="hourly" <?=($cfg['schedule_type']=='hourly')?'selected':''?>>Hourly</option>
            <option value="daily" <?=($cfg['schedule_type']=='daily')?'selected':''?>>Daily</option>
            <option value="weekly" <?=($cfg['schedule_type']=='weekly')?'selected':''?>>Weekly</option>
            <option value="monthly" <?=($cfg['schedule_type']=='monthly')?'selected':''?>>Monthly</option>
            <option value="custom" <?=($cfg['schedule_type']=='custom')?'selected':''?>>Custom</option>
        </select>
    </dd>
</dl>

<div id="schedule_time" style="display:none">
    <dl>
        <dt>Time:</dt>
        <dd>
            <select name="schedule_hour">
                <? for ($h = 0; $h < 24; $h++): ?>
                <option value="<?=$h?>" <?=($cfg['schedule_hour']==$h)?'selected':''?>>
                    <?=sprintf("%02d:00", $h)?>
                </option>
                <? endfor; ?>
            </select>
        </dd>
    </dl>
</div>

<script>
function toggleSchedule(type) {
    var timeDiv = document.getElementById('schedule_time');
    timeDiv.style.display = (type !== 'disabled') ? 'block' : 'none';
}
// Initialize on load
toggleSchedule(document.querySelector('[name="schedule_type"]').value);
</script>
```

### Writing the Cron Entry from Settings

When the user saves settings, write the cron file:

```php
<?
// In your update.php or settings handler
function updateCronSchedule($cfg) {
    $cronFile = "/etc/cron.d/yourplugin";
    
    if ($cfg['schedule_type'] === 'disabled') {
        // Remove cron job
        @unlink($cronFile);
        return;
    }
    
    // Build cron schedule based on type
    switch ($cfg['schedule_type']) {
        case 'hourly':
            $schedule = "0 * * * *";
            break;
        case 'daily':
            $hour = intval($cfg['schedule_hour']);
            $schedule = "0 $hour * * *";
            break;
        case 'weekly':
            $hour = intval($cfg['schedule_hour']);
            $dow = intval($cfg['schedule_dow']);
            $schedule = "0 $hour * * $dow";
            break;
        case 'monthly':
            $hour = intval($cfg['schedule_hour']);
            $dom = intval($cfg['schedule_dom']);
            $schedule = "0 $hour $dom * *";
            break;
        case 'custom':
            $schedule = $cfg['schedule_custom'];
            break;
    }
    
    // Write cron file
    $cronEntry = "$schedule root /usr/local/emhttp/plugins/yourplugin/scripts/scheduled_task.sh >/dev/null 2>&1\n";
    file_put_contents($cronFile, $cronEntry);
}
?>
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
| `0 * * * *` | Every hour (on the hour) |
| `*/5 * * * *` | Every 5 minutes |
| `0 0 * * *` | Daily at midnight |
| `0 3 * * *` | Daily at 3:00 AM |
| `0 3 * * 0` | Weekly on Sunday at 3 AM |
| `0 0 1 * *` | Monthly on the 1st at midnight |
| `0 4 * * 1-5` | Weekdays at 4:00 AM |
| `*/15 9-17 * * *` | Every 15 min during 9 AM - 5 PM |

## User Context

Always specify the user (typically `root`) in `/etc/cron.d/` files:

```
* * * * * root /path/to/script.sh
```

{: .warning }
> Unlike user crontabs, `/etc/cron.d/` files require the username field. Omitting it will cause your job to fail silently.

## Logging Output

```bash
# Discard output (silent)
0 * * * * root /script.sh >/dev/null 2>&1

# Log to file
0 * * * * root /script.sh >> /var/log/yourplugin.log 2>&1

# Log to syslog
0 * * * * root /script.sh 2>&1 | logger -t yourplugin

# Log with timestamp to file
0 * * * * root /script.sh >> /var/log/yourplugin.log 2>&1 && echo "$(date): Task completed" >> /var/log/yourplugin.log
```

## Persistence

Remember that `/etc/cron.d/` is in RAM. Your cron jobs must be recreated:
- On boot (via PLG FILE element or rc.d script)
- After array start if they depend on array

### Ensuring Cron Jobs Persist

**Option 1: PLG FILE element** (recommended for static schedules)
```xml
<FILE Name="/etc/cron.d/yourplugin">
<INLINE>
0 * * * * root /usr/local/emhttp/plugins/yourplugin/scripts/task.sh &gt;/dev/null 2&gt;&amp;1
</INLINE>
</FILE>
```

**Option 2: rc.d script** (recommended for configurable schedules)
```bash
#!/bin/bash
# /etc/rc.d/rc.yourplugin
PLUGIN="yourplugin"
CRONFILE="/etc/cron.d/$PLUGIN"
CONFIG="/boot/config/plugins/$PLUGIN/$PLUGIN.cfg"

case "$1" in
  'start')
    # Read schedule from config and write cron entry
    if [ -f "$CONFIG" ]; then
        source "$CONFIG"
        if [ -n "$SCHEDULE" ] && [ "$SCHEDULE" != "disabled" ]; then
            echo "$SCHEDULE root /usr/local/emhttp/plugins/$PLUGIN/scripts/task.sh >/dev/null 2>&1" > "$CRONFILE"
        fi
    fi
    ;;
  'stop')
    rm -f "$CRONFILE"
    ;;
  'restart')
    $0 stop
    $0 start
    ;;
esac
```

**Option 3: Event script** (for array-dependent tasks)
```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/event/started_array
echo "0 * * * * root /usr/local/emhttp/plugins/yourplugin/scripts/array_task.sh >/dev/null 2>&1" > /etc/cron.d/yourplugin_array
```

## Running Scripts at Specific Array States

Sometimes you want cron jobs only when the array is running:

```bash
#!/bin/bash
# /usr/local/emhttp/plugins/yourplugin/scripts/conditional_task.sh

# Check if array is started
if [ ! -d /mnt/user ]; then
    logger -t "yourplugin" "Array not started, skipping task"
    exit 0
fi

# Your task here
logger -t "yourplugin" "Running scheduled task"
```

## Debugging Cron Jobs

### Check if cron is running
```bash
ps aux | grep cron
```

### View cron execution in syslog
```bash
tail -f /var/log/syslog | grep CRON
```

### Test your script manually
```bash
/usr/local/emhttp/plugins/yourplugin/scripts/task.sh
echo $?  # Check exit code
```

### Verify cron file syntax
```bash
cat /etc/cron.d/yourplugin
# Ensure: schedule user command format
# Ensure: file has newline at end
```

## Best Practices

1. **Always escape XML entities** in PLG files (`>` becomes `&gt;`, `&` becomes `&amp;`)
2. **Redirect output** to avoid email spam from cron
3. **Add logging** for debugging scheduled tasks
4. **Check array state** before accessing array paths
5. **Use locking** to prevent overlapping runs of long tasks:

```bash
#!/bin/bash
LOCKFILE="/var/run/yourplugin_task.lock"

# Check for existing lock
if [ -f "$LOCKFILE" ]; then
    # Check if process is actually running
    PID=$(cat "$LOCKFILE")
    if kill -0 "$PID" 2>/dev/null; then
        logger -t "yourplugin" "Task already running (PID $PID)"
        exit 0
    fi
fi

# Create lock
echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

# Your task here
sleep 60
logger -t "yourplugin" "Task completed"
```

## Related Topics

- [PLG File Reference]({% link docs/plg-file.md %})
- [rc.d Scripts]({% link docs/core/rc-d-scripts.md %})
- [Event System]({% link docs/events.md %})
