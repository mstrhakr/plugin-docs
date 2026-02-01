---
layout: default
title: Array/Disk Access
parent: Advanced Topics
nav_order: 2
---

# Array/Disk Access

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Plugins can read disk information, share configurations, and array status to provide disk management features or integrate with Unraid's storage system.

## Array Status

### The $var Array

```php
<?
// Global array containing system state
global $var;

// Array status
$arrayStatus = $var['fsState']; // Started, Stopped, etc.

// Check if array is started
$arrayStarted = ($var['fsState'] == 'Started');
?>
```

### Common $var Properties

| Property | Description |
|----------|-------------|
| `$var['fsState']` | Array state (Started, Stopped, etc.) |
| `$var['mdState']` | MD device state |
| `$var['sbNumDisks']` | Number of data disks |
| `$var['sbNumParity']` | Number of parity disks |
| `$var['csrf_token']` | CSRF token |

## Disk Information

### Reading Disk Data

```php
<?
// Disk information is typically in /var/local/emhttp/
$disks = parse_ini_file('/var/local/emhttp/disks.ini', true);

foreach ($disks as $disk => $info) {
    echo "Disk: $disk\n";
    echo "Device: " . $info['device'] . "\n";
    echo "Size: " . $info['size'] . "\n";
    echo "Status: " . $info['status'] . "\n";
}
?>
```

### Disk Properties

TODO: Document available disk properties

| Property | Description |
|----------|-------------|
| `device` | Device name (sda, sdb, etc.) |
| `size` | Disk size in bytes |
| `status` | Disk status |
| `temp` | Temperature |
| `serial` | Serial number |

## Share Information

### Reading Shares

```php
<?
// Share configuration
$shares = parse_ini_file('/var/local/emhttp/shares.ini', true);

foreach ($shares as $share => $info) {
    echo "Share: $share\n";
    echo "Path: /mnt/user/$share\n";
    echo "Free: " . $info['free'] . "\n";
}
?>
```

### User Shares vs Disk Shares

```
/mnt/user/ShareName    # User share (combined view)
/mnt/disk1/ShareName   # Disk-specific path
/mnt/cache/ShareName   # Cache disk path
```

## Checking Disk Space

```php
<?
function getDiskSpace($path) {
    $total = disk_total_space($path);
    $free = disk_free_space($path);
    $used = $total - $free;
    
    return [
        'total' => $total,
        'free' => $free,
        'used' => $used,
        'percent' => round(($used / $total) * 100, 1)
    ];
}

$userSpace = getDiskSpace('/mnt/user');
?>
```

## Parity Operations

TODO: Document how to check/interact with parity operations

```php
<?
// Check if parity check is running
// $var properties related to parity status
?>
```

## SMART Data

```php
<?
// Get SMART data for a disk
$device = '/dev/sda';
exec("smartctl -A " . escapeshellarg($device), $output);

// Parse SMART attributes
// TODO: Document parsing patterns
?>
```

## Safe Practices

### Check Array State

```php
<?
global $var;

function requireArrayStarted() {
    global $var;
    if ($var['fsState'] !== 'Started') {
        die("Array must be started for this operation");
    }
}
?>
```

### Check Path Safety

```php
<?
function isSafePath($path) {
    // Ensure path is within allowed directories
    $allowed = ['/mnt/user/', '/mnt/cache/', '/mnt/disk'];
    foreach ($allowed as $prefix) {
        if (strpos($path, $prefix) === 0) {
            return true;
        }
    }
    return false;
}
?>
```

## Events for Array Changes

| Event | When Triggered |
|-------|----------------|
| `starting_array` | Array starting |
| `started_array` | Array fully started |
| `stopping_array` | Array stopping |
| `stopped_array` | Array fully stopped |
| `disk_added` | Disk added |

## Related Topics

- [Event System]({% link docs/events.md %})
- [File System Layout]({% link docs/filesystem.md %})
- [File Path Reference]({% link docs/reference/file-path-reference.md %})
