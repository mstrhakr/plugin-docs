---
layout: default
title: File Path Reference
parent: Reference
nav_order: 2
---

# File Path Reference

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

This reference provides a complete mapping of important directories and files in Unraid for plugin development.

## Persistence Quick Reference

| Location | Persists? | Notes |
|----------|-----------|-------|
| `/boot/` | ✅ Yes | USB flash drive |
| `/etc/` | ❌ No | RAM - recreated on boot |
| `/usr/local/` | ❌ No | RAM - recreated on boot |
| `/var/` | ❌ No | RAM - recreated on boot |
| `/mnt/user/` | ✅ Yes | Array shares |
| `/mnt/cache/` | ✅ Yes | Cache drive |
| `/mnt/disk*/` | ✅ Yes | Individual array disks |

## Plugin Directories

### Configuration (Persistent)

```
/boot/config/plugins/yourplugin/
├── yourplugin.cfg        # Main configuration
├── settings.cfg          # Additional settings
├── *.txz                 # Downloaded packages
└── custom/               # User customizations
```

### Runtime (RAM)

```
/usr/local/emhttp/plugins/yourplugin/
├── YourPlugin.page       # Main page
├── YourPluginSettings.page
├── *.php                 # PHP scripts
├── scripts/              # Shell scripts
│   ├── start.sh
│   └── stop.sh
├── include/              # Included PHP files
└── images/               # Plugin images
```

## Web Interface

### emhttp Root

```
/usr/local/emhttp/
├── plugins/              # Plugin pages
├── webGui/               # Core Unraid UI
│   ├── scripts/          # System scripts
│   │   └── notify        # Notification script
│   ├── include/          # PHP includes
│   └── images/           # UI images
└── state/                # Runtime state
```

### Page Files Search Order

```
/usr/local/emhttp/
├── plugins/yourplugin/*.page    # Plugin pages
└── webGui/*.page                # Core pages
```

## System Configuration

### /boot/config/

```
/boot/config/
├── docker.cfg            # Docker settings
├── disk.cfg              # Disk assignments
├── network.cfg           # Network configuration
├── ident.cfg             # Server identity
├── share.cfg             # Share settings
├── go                    # Startup script
├── plugins/              # Plugin configs
│   └── yourplugin/
└── super.dat             # Registration key
```

## State Files

### /var/local/emhttp/

Runtime state files (read-only for plugins):

```
/var/local/emhttp/
├── var.ini               # System variables
├── disks.ini             # Disk information
├── shares.ini            # Share information
├── users.ini             # User information
├── network.ini           # Network state
└── plugins/              # Plugin state files
```

## Service Management

### rc.d Scripts

```
/etc/rc.d/
├── rc.yourplugin         # Your service script
├── rc.docker             # Docker service
├── rc.nginx              # Web server
└── ...
```

### Cron

```
/etc/cron.d/
├── yourplugin            # Your cron jobs
└── ...
```

## Events

```
/usr/local/emhttp/plugins/yourplugin/event/
├── starting_array        # Runs when array starts
├── stopping_array        # Runs when array stops
├── docker_started        # Docker service started
└── ...
```

## Logging

```
/var/log/
├── syslog                # System log
├── messages              # General messages
└── yourplugin.log        # Your plugin log (if created)
```

## Docker

```
/var/lib/docker/          # Docker data (varies based on config)
/boot/config/plugins/dockerMan/
└── templates/            # Docker templates
```

## Temporary Files

```
/tmp/                     # Temporary files (RAM)
/var/tmp/                 # Temporary files (RAM)
```

## User Data

### Shares

```
/mnt/user/                # Combined user shares
/mnt/user/ShareName/      # Specific share

/mnt/disk1/ShareName/     # Disk-specific path
/mnt/disk2/ShareName/
/mnt/cache/ShareName/     # Cache path
```

### Appdata (Common Location)

```
/mnt/user/appdata/
└── yourplugin/           # Plugin data on array
```

## Common Absolute Paths

| Path | Description |
|------|-------------|
| `/usr/local/emhttp/plugins/yourplugin/` | Plugin runtime files |
| `/boot/config/plugins/yourplugin/` | Plugin config files |
| `/var/local/emhttp/var.ini` | System variables |
| `/var/local/emhttp/disks.ini` | Disk information |
| `/var/local/emhttp/shares.ini` | Share information |
| `/usr/local/emhttp/webGui/scripts/notify` | Notification script |
| `/etc/rc.d/rc.yourplugin` | Service script |
| `/etc/cron.d/yourplugin` | Cron jobs |
| `/var/run/yourplugin.pid` | PID file |
| `/var/log/syslog` | System log |

## Path Variables in PHP

```php
<?
// Common paths to define
define('PLUGIN_NAME', 'yourplugin');
define('PLUGIN_PATH', '/usr/local/emhttp/plugins/' . PLUGIN_NAME);
define('CONFIG_PATH', '/boot/config/plugins/' . PLUGIN_NAME);
define('CONFIG_FILE', CONFIG_PATH . '/' . PLUGIN_NAME . '.cfg');

// State files
$VAR_FILE = '/var/local/emhttp/var.ini';
$DISKS_FILE = '/var/local/emhttp/disks.ini';
$SHARES_FILE = '/var/local/emhttp/shares.ini';
?>
```

## Related Topics

- [File System Layout]({% link docs/filesystem.md %})
- [Plugin Settings Storage]({% link docs/core/plugin-settings-storage.md %})
- [PLG File Reference]({% link docs/plg-file.md %})
