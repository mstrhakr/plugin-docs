---
layout: default
title: Notifications System
parent: Core Concepts
nav_order: 6
---

# Notifications System

{: .note }
> ✅ **Validated against Unraid 7.2.3** - Notify script location and options verified.

## Overview

Unraid has a built-in notification system that plugins can use to alert users. Notifications can appear in the web UI and optionally be sent via email, Pushover, Discord, Telegram, Slack, and other notification agents.

## The notify Script

The notification system is accessed via the `notify` script:

```bash
# Location: /usr/local/emhttp/webGui/scripts/notify

# Basic usage
/usr/local/emhttp/webGui/scripts/notify \
    -e "Event Name" \
    -s "Subject Line" \
    -d "Detailed description" \
    -i "normal" \
    -m "Message body"
```

## Complete Notification Options

| Option | Required | Description | Example |
|--------|----------|-------------|---------||
| `-e` | Yes | Event name (category/source) | `-e "My Plugin"` |
| `-s` | Yes | Subject line (title) | `-s "Task Complete"` |
| `-d` | No | Short description | `-d "Backup finished"` |
| `-i` | No | Importance level | `-i "warning"` |
| `-m` | No | Full message body | `-m "Detailed message..."` |
| `-l` | No | Link URL (clickable in UI) | `-l "/Settings/MyPlugin"` |
| `-x` | No | Delete matching notification | `-x` |
| `-t` | No | Timestamp (Unix epoch) | `-t "$(date +%s)"` |
| `-b` | No | Broadcast (send even if suppressed) | `-b` |

### Importance Levels (-i)

| Level | Icon | When to Use |
|-------|------|-------------|
| `normal` | ℹ️ Blue info | Informational messages, successful completions |
| `warning` | ⚠️ Yellow warning | Issues requiring attention, non-critical problems |
| `alert` | 🚨 Red alert | Critical errors, failures, security issues |

The plugin system shows success messages like this:

![Success message example](../assets/images/screenshots/plugins-install-complete.png){: .crop-pluginsComplete-message }

{: .placeholder-image }
> 📷 **Screenshot needed:** *Notification panel showing different importance levels*
>
> ![Notifications](../assets/images/screenshots/notifications-panel.png)

## Basic Examples

### PHP Example

```php
<?
// Send a notification from PHP
$event = "My Plugin";
$subject = "Task Complete";
$description = "The scheduled task finished successfully";
$importance = "normal";

exec("/usr/local/emhttp/webGui/scripts/notify " .
     "-e " . escapeshellarg($event) . " " .
     "-s " . escapeshellarg($subject) . " " .
     "-d " . escapeshellarg($description) . " " .
     "-i " . escapeshellarg($importance));
?>
```

### Bash Script Example

```bash
#!/bin/bash
# Notification from a script

/usr/local/emhttp/webGui/scripts/notify \
    -e "Backup Plugin" \
    -s "Backup Complete" \
    -d "Backup of share 'Media' completed successfully" \
    -i "normal"
```

## Advanced Usage

### Notification with Link

Add a clickable link that takes the user to a specific page:

```bash
/usr/local/emhttp/webGui/scripts/notify \
    -e "My Plugin" \
    -s "Action Required" \
    -d "Please review settings" \
    -i "warning" \
    -l "/Settings/MyPluginSettings"
```

In PHP:

```php
<?
$link = "/Settings/MyPluginSettings";
exec("/usr/local/emhttp/webGui/scripts/notify " .
     "-e " . escapeshellarg("My Plugin") . " " .
     "-s " . escapeshellarg("Action Required") . " " .
     "-d " . escapeshellarg("Please review settings") . " " .
     "-i warning " .
     "-l " . escapeshellarg($link));
?>
```

### Notification with Full Message Body

```bash
/usr/local/emhttp/webGui/scripts/notify \
    -e "Backup Plugin" \
    -s "Backup Report" \
    -d "Daily backup completed" \
    -i "normal" \
    -m "Backup Statistics:
- Files backed up: 1,234
- Total size: 45.6 GB
- Duration: 23 minutes
- Errors: 0"
```

### Deleting/Dismissing Notifications

Use `-x` to delete a previously sent notification (matches by event and subject):

```bash
# Clear a specific notification
/usr/local/emhttp/webGui/scripts/notify \
    -e "My Plugin" \
    -s "Task Running" \
    -x

# Common pattern: Clear "running" notification when task completes
/usr/local/emhttp/webGui/scripts/notify \
    -e "My Plugin" \
    -s "Task Running" \
    -x

/usr/local/emhttp/webGui/scripts/notify \
    -e "My Plugin" \
    -s "Task Complete" \
    -d "Task finished successfully" \
    -i "normal"
```

### Custom Timestamp

Specify a custom timestamp (useful for delayed processing):

```bash
# Notification with specific timestamp
TIMESTAMP=$(date +%s)
/usr/local/emhttp/webGui/scripts/notify \
    -e "My Plugin" \
    -s "Event Occurred" \
    -d "Something happened" \
    -i "normal" \
    -t "$TIMESTAMP"
```

## Notification Agents

Users configure notification agents in Settings → Notification Settings. Your notifications will automatically be sent to all enabled agents.

### Built-in Agents

| Agent | Configuration Location |
|-------|------------------------|
| Email | Settings → Notification Settings |
| Pushover | Requires Pushover app |
| Telegram | Requires bot token |
| Discord | Requires webhook URL |
| Slack | Requires webhook URL |

### Notification Agent Settings

Notification agents are configured in `/boot/config/plugins/dynamix/notifications/`:

```
/boot/config/plugins/dynamix/notifications/
├── email.cfg           # Email configuration
├── pushover.cfg        # Pushover configuration
├── telegram.cfg        # Telegram bot configuration
├── discord.cfg         # Discord webhook
└── slack.cfg           # Slack webhook
```

### Custom Notification Agent

Plugins can register custom notification agents by creating agent configuration files. See the existing agents in `/usr/local/emhttp/webGui/notifications/` for reference.

## PHP Notification Helper Function

Create a reusable function for your plugin:

```php
<?
/**
 * Send an Unraid notification
 * 
 * @param string $subject Subject line
 * @param string $description Short description
 * @param string $importance normal|warning|alert
 * @param string $message Full message body (optional)
 * @param string $link URL link (optional)
 */
function sendNotification($subject, $description, $importance = 'normal', $message = '', $link = '') {
    $event = "My Plugin";  // Your plugin name
    
    $cmd = "/usr/local/emhttp/webGui/scripts/notify " .
           "-e " . escapeshellarg($event) . " " .
           "-s " . escapeshellarg($subject) . " " .
           "-d " . escapeshellarg($description) . " " .
           "-i " . escapeshellarg($importance);
    
    if ($message) {
        $cmd .= " -m " . escapeshellarg($message);
    }
    
    if ($link) {
        $cmd .= " -l " . escapeshellarg($link);
    }
    
    exec($cmd);
}

// Usage examples
sendNotification("Backup Complete", "Daily backup finished", "normal");
sendNotification("Disk Warning", "Disk1 SMART warning detected", "warning", 
                 "Temperature: 55°C\nReallocated Sectors: 5", "/Main/Disk1");
sendNotification("Array Stopped", "Array stopped unexpectedly", "alert");
?>
```

## Bash Notification Helper Function

```bash
#!/bin/bash
# notification-helper.sh

# Notification function
notify() {
    local event="My Plugin"
    local subject="$1"
    local description="$2"
    local importance="${3:-normal}"
    local message="$4"
    local link="$5"
    
    local cmd="/usr/local/emhttp/webGui/scripts/notify"
    cmd="$cmd -e \"$event\""
    cmd="$cmd -s \"$subject\""
    cmd="$cmd -d \"$description\""
    cmd="$cmd -i $importance"
    
    [ -n "$message" ] && cmd="$cmd -m \"$message\""
    [ -n "$link" ] && cmd="$cmd -l \"$link\""
    
    eval $cmd
}

# Usage
notify "Task Complete" "Scheduled task finished" "normal"
notify "Error" "Task failed" "alert" "Exit code: 1" "/Settings/MyPlugin"
```

## Notification Storage

Notifications are stored in `/boot/config/plugins/dynamix/notifications/`:

```
/boot/config/plugins/dynamix/notifications/
├── archive/            # Archived (dismissed) notifications
└── *.notify            # Active notifications
```

Each notification is stored as a file with the format:
```
timestamp_event_subject.notify
```

## Best Practices

1. **Use appropriate importance levels** - Don't cry wolf with alerts
2. **Be concise** - Subject and description should be brief
3. **Include actionable links** - Help users navigate to relevant pages
4. **Don't spam** - Consolidate multiple events into summary notifications
5. **Clean up** - Use `-x` to dismiss transient status notifications
6. **Test all agents** - Notifications may render differently in email vs. Pushover
7. **Escape special characters** - Always use `escapeshellarg()` in PHP
8. **Consider timing** - Avoid sending many notifications in rapid succession

## Common Patterns

### Progress Notification Pattern

```bash
#!/bin/bash
# Show progress, then completion

# Start notification
/usr/local/emhttp/webGui/scripts/notify \
    -e "My Plugin" \
    -s "Task Running" \
    -d "Processing files..." \
    -i "normal"

# Do the work
process_files

# Clear progress, show completion
/usr/local/emhttp/webGui/scripts/notify -e "My Plugin" -s "Task Running" -x

/usr/local/emhttp/webGui/scripts/notify \
    -e "My Plugin" \
    -s "Task Complete" \
    -d "Processed 100 files" \
    -i "normal"
```

### Error with Recovery Steps

```php
<?
sendNotification(
    "Configuration Error",
    "Invalid settings detected",
    "warning",
    "The following settings need attention:\n" .
    "- Path '/mnt/user/invalid' does not exist\n" .
    "- Schedule format is invalid\n\n" .
    "Click the link below to fix these settings.",
    "/Settings/MyPluginSettings"
);
?>
```

## Related Topics

- [Event System](events.md)
- [Cron Jobs](cron-jobs.md)
- [rc.d Scripts](rc-d-scripts.md)
