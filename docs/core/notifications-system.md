---
layout: default
title: Notifications System
parent: Core Concepts
nav_order: 6
---

# Notifications System

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Unraid has a built-in notification system that plugins can use to alert users. Notifications can appear in the web UI and optionally be sent via email, Pushover, Discord, etc.

## The notify Script

```bash
# Location: /usr/local/emhttp/webGui/scripts/notify

# Basic usage
/usr/local/emhttp/webGui/scripts/notify \
    -e "Event Name" \
    -s "Subject Line" \
    -d "Detailed description" \
    -i "normal|warning|alert" \
    -m "Message body"
```

## Notification Options

| Option | Description |
|--------|-------------|
| `-e` | Event name (category) |
| `-s` | Subject line |
| `-d` | Description |
| `-i` | Importance: `normal`, `warning`, or `alert` |
| `-m` | Message body |
| `-l` | Link URL (optional) |
| `-x` | TODO: Document |

## PHP Example

```php
<?
// Send a notification from PHP
$event = "My Plugin";
$subject = "Task Complete";
$description = "The scheduled task finished successfully";
$importance = "normal"; // normal, warning, alert

exec("/usr/local/emhttp/webGui/scripts/notify " .
     "-e " . escapeshellarg($event) . " " .
     "-s " . escapeshellarg($subject) . " " .
     "-d " . escapeshellarg($description) . " " .
     "-i " . escapeshellarg($importance));
?>
```

## Bash Script Example

```bash
#!/bin/bash
# Notification from a script

/usr/local/emhttp/webGui/scripts/notify \
    -e "Backup Plugin" \
    -s "Backup Complete" \
    -d "Backup of share 'Media' completed successfully" \
    -i "normal"
```

## Notification Levels

| Level | Icon | Use Case |
|-------|------|----------|
| `normal` | ℹ️ | Informational messages |
| `warning` | ⚠️ | Issues requiring attention |
| `alert` | 🚨 | Critical errors |

## Best Practices

TODO: Document best practices

- Don't spam notifications
- Use appropriate severity levels
- Provide actionable information
- Include relevant links when helpful

## Related Topics

- [Event System]({% link docs/events.md %})
- [Cron Jobs]({% link docs/core/cron-jobs.md %})
