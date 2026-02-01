---
layout: default
title: File Path Reference
parent: Reference
nav_order: 2
---

# File Path Reference

{: .note }
> ✅ **Validated against Unraid 7.2.3** - Directory paths and persistence behavior verified.

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
/var/lib/docker/                    # Docker data (varies based on config)
/var/run/docker.sock                # Docker socket
/boot/config/docker.cfg             # Docker configuration
/boot/config/plugins/dockerMan/
├── templates/                      # Saved Docker templates
├── templates-user/                 # User-created templates
└── images/                         # Container icons
```

### Docker Template Locations

```
/boot/config/plugins/dockerMan/templates-user/my-[Container].xml
```

## Temporary Files

```
/tmp/                              # Temporary files (RAM) - cleared on boot
├── plugins/                       # Plugin temp data
├── yourplugin_work/               # Working directory
└── phpXXXXXX                       # PHP temp files

/var/tmp/                          # Temporary files (RAM) - may persist longer
/run/                              # Runtime data (symlink to /var/run)
/var/run/                          # Runtime data
├── yourplugin.pid                 # Plugin PID files
├── yourplugin.sock                # Plugin sockets
└── docker.sock                    # Docker socket
```

## Logging

```
/var/log/
├── syslog                         # Main system log
├── messages                       # General messages
├── dmesg                          # Kernel messages
├── nginx/                         # Web server logs
│   ├── access.log
│   └── error.log
├── docker.log                     # Docker daemon log (if enabled)
├── libvirt/                       # VM logs
│   └── qemu/
└── yourplugin.log                 # Plugin-specific log (if created)
```

### Plugin Logging Locations

Plugins can write logs to several locations:

```php
<?
// Option 1: /var/log/ (RAM, lost on reboot)
$logFile = "/var/log/yourplugin.log";

// Option 2: Plugin config dir (persistent)
$logFile = "/boot/config/plugins/yourplugin/yourplugin.log";

// Option 3: Array location (if array needed anyway)
$logFile = "/mnt/user/appdata/yourplugin/logs/yourplugin.log";
?>
```

## User Data

### Shares

```
/mnt/user/                         # Combined user shares view
├── ShareName/                     # Specific share
├── appdata/                       # Common container data location
│   └── yourplugin/                # Your plugin's data
├── domains/                       # VM disk images
└── isos/                          # ISO files

/mnt/disk1/ShareName/              # Direct disk access
/mnt/disk2/ShareName/
/mnt/cache/ShareName/              # Cache drive access
/mnt/cache_nvme/ShareName/         # Named pool access
```

### Appdata (Common Location)

```
/mnt/user/appdata/
├── yourplugin/                    # Plugin data on array
│   ├── config/
│   ├── data/
│   └── logs/
├── binhex-plexpass/               # Example container
└── ...
```

## Cache/Pools

```
/mnt/cache/                        # Default cache pool
/mnt/pool_name/                    # Named pools
/mnt/cache_nvme/                   # Example: NVMe cache pool
```

## Network Configuration

```
/boot/config/
├── network.cfg                    # Network settings
├── network-rules.cfg              # Network rules
└── wireguard/                     # WireGuard configs (if enabled)
    └── wg0.conf
```

## SSL/Certificates

```
/boot/config/ssl/
├── certs/
│   ├── certificate_bundle.pem    # SSL certificate
│   └── yourserver_unraid_net.key # Private key
└── ...

/etc/ssl/                          # System SSL certificates
```

## Flash Drive Layout

```
/boot/                             # Flash drive root (FAT32)
├── bzimage                        # Linux kernel
├── bzroot                         # Initial ramdisk
├── bzroot-gui                     # GUI components
├── bzmodules                      # Kernel modules
├── bzfirmware                     # Firmware files
├── syslinux/                      # Bootloader
├── config/                        # All configuration
│   ├── go                         # Startup script
│   ├── ident.cfg                  # Server identity
│   ├── disk.cfg                   # Disk config
│   ├── share.cfg                  # Share config
│   ├── network.cfg                # Network config
│   ├── docker.cfg                 # Docker config
│   ├── domain.cfg                 # VM config
│   ├── modprobe.d/                # Kernel module options
│   └── plugins/                   # Plugin configs
└── extra/                         # Extra packages to load
```

## Common Absolute Paths

### Plugin Development

| Path | Description |
|------|-------------|
| `/usr/local/emhttp/plugins/yourplugin/` | Plugin runtime files (RAM) |
| `/boot/config/plugins/yourplugin/` | Plugin config files (persistent) |
| `/usr/local/emhttp/webGui/` | Core web interface |
| `/usr/local/emhttp/webGui/include/` | PHP includes |
| `/usr/local/emhttp/webGui/scripts/` | System scripts |

### State Files

| Path | Description |
|------|-------------|
| `/var/local/emhttp/var.ini` | System variables ($var) |
| `/var/local/emhttp/disks.ini` | Disk information |
| `/var/local/emhttp/shares.ini` | Share information |
| `/var/local/emhttp/users.ini` | User information |
| `/var/local/emhttp/network.ini` | Network state |
| `/var/local/emhttp/devs.ini` | Device information |

### System Utilities

| Path | Description |
|------|-------------|
| `/usr/local/emhttp/webGui/scripts/notify` | Notification script |
| `/usr/local/sbin/emhttp` | Main emhttp daemon |
| `/etc/rc.d/rc.docker` | Docker service script |
| `/etc/rc.d/rc.nginx` | Nginx service script |

### Service Management

| Path | Description |
|------|-------------|
| `/etc/rc.d/rc.yourplugin` | Your service script |
| `/etc/cron.d/yourplugin` | Your cron jobs |
| `/var/run/yourplugin.pid` | Your PID file |

## Path Variables in PHP

```php
<?
// Plugin path constants
define('PLUGIN_NAME', 'yourplugin');
define('PLUGIN_PATH', '/usr/local/emhttp/plugins/' . PLUGIN_NAME);
define('CONFIG_PATH', '/boot/config/plugins/' . PLUGIN_NAME);
define('CONFIG_FILE', CONFIG_PATH . '/' . PLUGIN_NAME . '.cfg');

// State files
define('VAR_FILE', '/var/local/emhttp/var.ini');
define('DISKS_FILE', '/var/local/emhttp/disks.ini');
define('SHARES_FILE', '/var/local/emhttp/shares.ini');
define('USERS_FILE', '/var/local/emhttp/users.ini');

// Common paths
define('DOCROOT', '/usr/local/emhttp');
define('WEBGUI_PATH', DOCROOT . '/webGui');
define('NOTIFY_SCRIPT', WEBGUI_PATH . '/scripts/notify');

// Usage
$var = parse_ini_file(VAR_FILE);
$disks = parse_ini_file(DISKS_FILE, true);
$cfg = parse_plugin_cfg(PLUGIN_NAME);
?>
```

## Path Variables in Bash

```bash
#!/bin/bash

# Plugin paths
PLUGIN="yourplugin"
PLUGIN_PATH="/usr/local/emhttp/plugins/$PLUGIN"
CONFIG_PATH="/boot/config/plugins/$PLUGIN"
CONFIG_FILE="$CONFIG_PATH/$PLUGIN.cfg"

# System paths
EMHTTP="/usr/local/emhttp"
NOTIFY="$EMHTTP/webGui/scripts/notify"

# State files
VAR_FILE="/var/local/emhttp/var.ini"
```

## Related Topics

- [File System Layout](../filesystem.md)
- [Plugin Settings Storage](../core/plugin-settings-storage.md)
- [PLG File Reference](../plg-file.md)
- [Var Array Reference](var-array-reference.md)
