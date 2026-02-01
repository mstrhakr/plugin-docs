---
layout: default
title: Array/Disk Access
parent: Advanced Topics
nav_order: 2
---

# Array/Disk Access

## Overview

Plugins can read disk information, share configurations, and array status to provide disk management features or integrate with Unraid's storage system. This page covers how to access disk and array information from your plugin code.

## Array Status

### The $var Array

The `$var` array contains system state including array status:

```php
<?
// Load system state
$var = parse_ini_file('/var/local/emhttp/var.ini');

// Or use global if already loaded
global $var;

// Array status
$arrayStatus = $var['fsState'];  // "Started", "Stopped", "Starting", "Stopping"
$mdState = $var['mdState'];      // "STARTED", "STOPPED", etc.

// Check if array is started
$arrayStarted = ($var['fsState'] === 'Started');

// Check if array is usable (not in transition)
$arrayReady = ($var['fsState'] === 'Started' && $var['mdState'] === 'STARTED');
?>
```

### Common $var Array Properties

| Property | Description | Values |
|----------|-------------|--------|
| `fsState` | Array filesystem state | `Started`, `Stopped`, `Starting`, `Stopping` |
| `mdState` | MD device state | `STARTED`, `STOPPED`, `RESYNCING`, etc. |
| `mdNumDisks` | Number of array data disks | Integer |
| `mdNumDisabled` | Number of disabled disks | Integer |
| `mdNumMissing` | Number of missing disks | Integer |
| `mdResync` | Current resync position | Block number (0 if not resyncing) |
| `mdResyncSize` | Total resync size | Block count |
| `mdResyncAction` | Type of resync | `check`, `repair`, `sync` |

### Parity Check Status

```php
<?
$var = parse_ini_file('/var/local/emhttp/var.ini');

// Check if parity operation is in progress
$parityRunning = !empty($var['mdResync']) && $var['mdResync'] !== '0';

if ($parityRunning) {
    $current = $var['mdResync'];
    $total = $var['mdResyncSize'];
    $percent = round(($current / $total) * 100, 2);
    $action = $var['mdResyncAction'] ?? 'check';
    
    echo "Parity $action in progress: $percent%";
}
?>
```

## Disk Information

### Reading All Disk Data

```php
<?
// Parse disks.ini with sections (true parameter)
$disks = parse_ini_file('/var/local/emhttp/disks.ini', true);

foreach ($disks as $diskName => $disk) {
    // $diskName: parity, parity2, disk1, disk2, cache, etc.
    echo "Disk: $diskName\n";
    echo "  Device: " . ($disk['device'] ?? 'unassigned') . "\n";
    echo "  ID: " . ($disk['id'] ?? 'unknown') . "\n";
    echo "  Size: " . ($disk['size'] ?? 0) . " KB\n";
    echo "  Status: " . ($disk['status'] ?? 'unknown') . "\n";
    echo "  Temp: " . ($disk['temp'] ?? '*') . "°C\n";
}
?>
```

### Disk Properties Reference

| Property | Description | Example |
|----------|-------------|---------|
| `device` | Device name | `sda`, `nvme0n1` |
| `id` | Disk serial/ID | `WDC_WD40EFRX_12345` |
| `size` | Size in KB | `3907029168` |
| `sizeSb` | Size in sectors | `7814037168` |
| `status` | Disk status code | `DISK_OK`, `DISK_DSBL`, `DISK_NP` |
| `temp` | Temperature in Celsius | `35`, `*` (unknown) |
| `fsType` | Filesystem type | `xfs`, `btrfs`, `reiserfs` |
| `fsSize` | Filesystem size | Bytes |
| `fsFree` | Free space | Bytes |
| `fsStatus` | Mount status | `Mounted`, `Unmounted` |
| `reads` | Read count | Integer |
| `writes` | Write count | Integer |
| `errors` | Error count | Integer |
| `numReads` | Total reads | Integer |
| `numWrites` | Total writes | Integer |

### Disk Status Codes

| Status | Meaning |
|--------|---------|
| `DISK_OK` | Disk is healthy |
| `DISK_DSBL` | Disk is disabled |
| `DISK_NP` | Disk not present (slot empty) |
| `DISK_INVALID` | Disk is invalid |
| `DISK_WRONG` | Wrong disk in slot |
| `DISK_NEW` | New unformatted disk |

### Filtering Disk Types

```php
<?
$disks = parse_ini_file('/var/local/emhttp/disks.ini', true);

// Get only array data disks
$arrayDisks = array_filter($disks, function($name) {
    return preg_match('/^disk\d+$/', $name);
}, ARRAY_FILTER_USE_KEY);

// Get parity disks
$parityDisks = array_filter($disks, function($name) {
    return strpos($name, 'parity') === 0;
}, ARRAY_FILTER_USE_KEY);

// Get cache pools
$cachePools = array_filter($disks, function($name) {
    return strpos($name, 'cache') === 0 || 
           (strpos($name, 'disk') !== 0 && strpos($name, 'parity') !== 0);
}, ARRAY_FILTER_USE_KEY);

// Get only assigned disks (with devices)
$assignedDisks = array_filter($disks, function($disk) {
    return !empty($disk['device']);
});
?>
```

## Share Information

### Reading All Shares

```php
<?
$shares = parse_ini_file('/var/local/emhttp/shares.ini', true);

foreach ($shares as $shareName => $share) {
    echo "Share: $shareName\n";
    echo "  Free: " . formatBytes($share['free']) . "\n";
    echo "  Size: " . formatBytes($share['size']) . "\n";
    echo "  Cache: " . ($share['useCache'] ?? 'no') . "\n";
}

function formatBytes($bytes, $precision = 2) {
    $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    return round($bytes / pow(1024, $pow), $precision) . ' ' . $units[$pow];
}
?>
```

### Share Properties

| Property | Description |
|----------|-------------|
| `name` | Share name |
| `free` | Free space in bytes |
| `size` | Total size in bytes |
| `include` | Included disks (comma-separated) |
| `exclude` | Excluded disks (comma-separated) |
| `useCache` | Cache setting: `yes`, `no`, `only`, `prefer` |
| `cow` | Copy-on-write setting |
| `security` | Security level |

### User Shares vs Disk Shares

```php
<?
// User share (combined view across all disks)
$userSharePath = "/mnt/user/ShareName";

// Disk-specific paths
$disk1Path = "/mnt/disk1/ShareName";
$disk2Path = "/mnt/disk2/ShareName";

// Cache disk path
$cachePath = "/mnt/cache/ShareName";

// Check if share exists on specific disk
function shareExistsOnDisk($shareName, $diskName) {
    $path = "/mnt/$diskName/$shareName";
    return is_dir($path);
}
?>
```

## Checking Disk Space

### Basic Disk Space

```php
<?
function getDiskSpace($path) {
    if (!is_dir($path)) {
        return null;
    }
    
    $total = disk_total_space($path);
    $free = disk_free_space($path);
    $used = $total - $free;
    
    return [
        'total' => $total,
        'free' => $free,
        'used' => $used,
        'percent' => $total > 0 ? round(($used / $total) * 100, 1) : 0
    ];
}

// Check user share space
$appdata = getDiskSpace('/mnt/user/appdata');
if ($appdata) {
    echo "Appdata: {$appdata['percent']}% used ({$appdata['free']} free)";
}
?>
```

### Array-Wide Space

```php
<?
function getArraySpace() {
    $shares = parse_ini_file('/var/local/emhttp/shares.ini', true);
    
    $totalFree = 0;
    $totalSize = 0;
    
    foreach ($shares as $share) {
        $totalFree += $share['free'];
        $totalSize += $share['size'];
    }
    
    return [
        'total' => $totalSize,
        'free' => $totalFree,
        'used' => $totalSize - $totalFree,
        'percent' => $totalSize > 0 ? round((($totalSize - $totalFree) / $totalSize) * 100, 1) : 0
    ];
}
?>
```

## SMART Data

### Reading SMART Attributes

```php
<?
function getSmartData($device) {
    // Ensure device path is safe
    if (!preg_match('/^\/dev\/[a-z]+$/', $device)) {
        return null;
    }
    
    $output = [];
    exec("smartctl -A " . escapeshellarg($device) . " 2>/dev/null", $output, $retval);
    
    if ($retval !== 0) {
        return null;
    }
    
    $attributes = [];
    foreach ($output as $line) {
        // Parse SMART attribute lines
        if (preg_match('/^\s*(\d+)\s+(\S+)\s+\S+\s+(\d+)\s+(\d+)\s+(\d+)\s+\S+\s+\S+\s+\S+\s+(.*)$/', $line, $matches)) {
            $attributes[$matches[2]] = [
                'id' => intval($matches[1]),
                'name' => $matches[2],
                'value' => intval($matches[3]),
                'worst' => intval($matches[4]),
                'thresh' => intval($matches[5]),
                'raw' => trim($matches[6])
            ];
        }
    }
    
    return $attributes;
}

// Key attributes to check
$smart = getSmartData('/dev/sda');
if ($smart) {
    $temp = $smart['Temperature_Celsius']['raw'] ?? 'Unknown';
    $reallocated = $smart['Reallocated_Sector_Ct']['raw'] ?? 0;
    $pending = $smart['Current_Pending_Sector']['raw'] ?? 0;
}
?>
```

### SMART Health Check

```php
<?
function isDiskHealthy($device) {
    exec("smartctl -H " . escapeshellarg($device) . " 2>/dev/null", $output, $retval);
    $outputStr = implode("\n", $output);
    return strpos($outputStr, 'PASSED') !== false;
}
?>
```

## Spin-Up and Spin-Down

### Check Disk State

```php
<?
function isDiskSpunUp($device) {
    exec("hdparm -C " . escapeshellarg($device) . " 2>/dev/null", $output);
    $outputStr = implode("\n", $output);
    return strpos($outputStr, 'active') !== false;
}
?>
```

{: .warning }
> Be mindful of disk spin-up. Reading data from a spun-down disk will cause it to spin up, increasing wear and power usage.

### Avoid Unnecessary Spin-Ups

```php
<?
function readIfSpunUp($device, $path, $callback) {
    // Check if disk is already active
    exec("hdparm -C " . escapeshellarg($device) . " 2>/dev/null", $output);
    $isActive = strpos(implode("\n", $output), 'active') !== false;
    
    if ($isActive) {
        return $callback($path);
    }
    
    return null;  // Skip if disk is asleep
}
?>
```

## Safe Practices

### Require Array Started

```php
<?
function requireArrayStarted() {
    $var = parse_ini_file('/var/local/emhttp/var.ini');
    
    if ($var['fsState'] !== 'Started') {
        http_response_code(503);
        die(json_encode([
            'error' => 'Array must be started for this operation'
        ]));
    }
}

// Use at start of scripts that need array access
requireArrayStarted();
?>
```

### Validate Paths

```php
<?
function isValidArrayPath($path) {
    // Resolve any symlinks and .. references
    $realPath = realpath($path);
    if ($realPath === false) {
        return false;
    }
    
    // Check against allowed prefixes
    $allowedPrefixes = [
        '/mnt/user/',
        '/mnt/disk',
        '/mnt/cache'
    ];
    
    foreach ($allowedPrefixes as $prefix) {
        if (strpos($realPath, $prefix) === 0) {
            return true;
        }
    }
    
    return false;
}

// Prevent path traversal attacks
$userPath = $_POST['path'] ?? '';
if (!isValidArrayPath($userPath)) {
    die("Invalid path");
}
?>
```

### Handle Unmounted Disks

```php
<?
function safeReadFromDisk($diskPath) {
    // Check if mounted
    if (!is_dir($diskPath)) {
        return ['error' => 'Disk not available'];
    }
    
    // Check if mount point (not empty directory)
    $mountOutput = shell_exec("mountpoint -q " . escapeshellarg($diskPath) . " && echo 'mounted'");
    if (trim($mountOutput) !== 'mounted') {
        return ['error' => 'Disk not mounted'];
    }
    
    // Safe to proceed
    return ['data' => scandir($diskPath)];
}
?>
```

## Events for Array Changes

Use event scripts to respond to array state changes:

| Event | When Triggered | Common Use |
|-------|----------------|------------|
| `starting_array` | Array beginning to start | Prepare resources |
| `started_array` | Array fully started/mounted | Start services, initialize data |
| `stopping_array` | Array beginning to stop | Stop services, save state |
| `stopped_array` | Array fully stopped/unmounted | Cleanup |
| `unmounting_disk` | Before specific disk unmounts | Release handles |
| `disk_added` | New disk added | Initialize disk |

See [Event Types Reference](../reference/event-types-reference.md) for details.

## Related Topics

- [Event System](../events.md)
- [File System Layout](../filesystem.md)
- [File Path Reference](../reference/file-path-reference.md)
- [Var Array Reference](../reference/var-array-reference.md)
