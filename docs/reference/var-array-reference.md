---
layout: default
title: Var Array Reference
parent: Reference
nav_order: 4
---

# $var Array Reference

{: .note }
> ✅ **Validated against Unraid 7.2.3** - All properties verified against `/var/local/emhttp/var.ini` on live systems.
>
> See the [DocTest validation plugin](https://github.com/mstrhakr/plugin-docs/blob/main/validation/plugin/source/emhttp/DocTest.page) for a working example that displays `$var` array values.

## Overview

The `$var` array contains system state and configuration variables. It's one of the most important globals for plugin development, providing access to array status, disk information, system identity, and security tokens.

## Accessing $var

In `.page` files, `$var` is typically pre-loaded by Unraid's framework. In standalone PHP scripts or AJAX handlers, load it manually from the INI file. Always use the `global` keyword when accessing it inside functions.

```php
<?
// In page files, $var is usually pre-loaded
global $var;

// In standalone scripts, load it manually
$var = parse_ini_file('/var/local/emhttp/var.ini');

// Example usage
$serverName = $var['NAME'];
$arrayState = $var['fsState'];
?>
```

## Source File

The `$var` array is populated from:
```
/var/local/emhttp/var.ini
```

This file is continuously updated by the Unraid system to reflect current state.

## Complete Property Reference

### System Identity

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `NAME` | string | Server name | `"Tower"` |
| `COMMENT` | string | Server description | `"Unraid Server"` |
| `localMaster` | string | Local master browser setting | `"yes"` |
| `timeZone` | string | Configured timezone | `"America/New_York"` |
| `USE_NTP` | string | NTP enabled | `"yes"`, `"no"` |
| `NTP_SERVER1` | string | Primary NTP server | `"pool.ntp.org"` |
| `NTP_SERVER2` | string | Secondary NTP server | `""` |

### Unraid Version

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `version` | string | Unraid OS version | `"6.12.6"` |
| `regTy` | string | Registration type | `"Basic"`, `"Plus"`, `"Pro"`, `"Trial"` |
| `regTo` | string | Registered to name | `"John Doe"` |
| `regTm` | string | Registration timestamp | Unix timestamp |
| `regGen` | string | Registration generation | `"1"` |
| `flashGUID` | string | Flash drive GUID | `"XXXX-XXXX-..."` |

### Array State

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `fsState` | string | Array filesystem state | `"Started"`, `"Stopped"` |
| `mdState` | string | MD device state | `"STARTED"`, `"STOPPED"`, `"RESYNCING"` |
| `mdResync` | string | Resync position (if active) | Block number |
| `mdResyncSize` | string | Total resync size | Block count |
| `mdResyncAction` | string | Resync action type | `"check"`, `"rebuild"`, `"sync"` |
| `md_num_stripes` | string | Number of stripes | `"1280"` |
| `mdNumDisks` | string | Number of array disks | `"4"` |
| `mdNumDisabled` | string | Number of disabled disks | `"0"` |
| `mdNumMissing` | string | Number of missing disks | `"0"` |
| `mdNumInvalid` | string | Number of invalid disks | `"0"` |
| `mdNumNew` | string | Number of new disks | `"0"` |

### Parity Information

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `parity.idx` | string | Parity disk index | `"0"` |
| `parity.id` | string | Parity disk ID | `"WDC_WD40EFRX..."` |
| `parity.device` | string | Parity device | `"sda"` |
| `parity.size` | string | Parity disk size (KB) | `"3907029168"` |
| `parity.status` | string | Parity disk status | `"DISK_OK"` |
| `parity.temp` | string | Temperature (C) | `"35"` |

### Cache/Pool Information

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `cacheSbName` | string | Cache pool name | `"cache"` |
| `cacheSbNumDisks` | string | Number of cache disks | `"2"` |
| `cachePoolState` | string | Cache pool state | `"STARTED"` |
| `cacheNumDevices` | string | Cache device count | `"2"` |

### Security

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `csrf_token` | string | CSRF token for forms | `"abc123..."` |
| `USE_SSL` | string | SSL enabled | `"yes"`, `"no"`, `"auto"` |
| `portssl` | string | HTTPS port | `"443"` |
| `port` | string | HTTP port | `"80"` |

### Network

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `USE_TELNET` | string | Telnet enabled | `"yes"`, `"no"` |
| `USE_SSH` | string | SSH enabled | `"yes"`, `"no"` |
| `LOCAL_TLD` | string | Local TLD | `"local"` |

### Display/UI

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `display` | string | Display settings reference | Various |
| `locale` | string | Current locale | `"en_US"` |

### Spin Settings

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `spindownDelay` | string | Spin-down delay (min) | `"30"` |
| `spinupGroups` | string | Spin-up groups config | Various |

### UPS

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `USE_UPS` | string | UPS monitoring enabled | `"yes"`, `"no"` |
| `UPS_DRIVER` | string | UPS driver | `"usbhid-ups"` |

## Common Usage Patterns

### Check Array State

```php
<?
global $var;

if ($var['fsState'] === 'Started') {
    // Array is running, safe to access shares
    $shares = parse_ini_file('/var/local/emhttp/shares.ini', true);
} else {
    echo "Array is not started";
}
?>
```

### Check if Parity Check Running

```php
<?
global $var;

$isResyncing = !empty($var['mdResync']) && $var['mdResync'] != '0';
if ($isResyncing) {
    $progress = round(($var['mdResync'] / $var['mdResyncSize']) * 100, 2);
    echo "Parity operation in progress: {$progress}%";
}
?>
```

### Get Server Information

```php
<?
global $var;

$serverInfo = [
    'name' => $var['NAME'],
    'version' => $var['version'],
    'registration' => $var['regTy'],
    'timezone' => $var['timeZone']
];
?>
```

### CSRF Token in Forms

```php
<?
global $var;
?>
<form method="POST" action="/update.php">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    <!-- form fields -->
</form>
```

### Check SSL Status

```php
<?
global $var;

$useSSL = $var['USE_SSL'] ?? 'no';
$isSecure = ($useSSL === 'yes' || $useSSL === 'auto');
$protocol = $isSecure ? 'https' : 'http';
$port = $isSecure ? $var['portssl'] : $var['port'];
?>
```

## Related State Files

The `$var` array is one of several state files:

| File | Content | Load With |
|------|---------|-----------|
| `var.ini` | System state | `parse_ini_file(..., false)` |
| `disks.ini` | Disk information | `parse_ini_file(..., true)` |
| `shares.ini` | Share information | `parse_ini_file(..., true)` |
| `users.ini` | User information | `parse_ini_file(..., true)` |
| `network.ini` | Network configuration | `parse_ini_file(..., true)` |

### Loading Related Data

```php
<?
// Load all state data
$var = parse_ini_file('/var/local/emhttp/var.ini');
$disks = parse_ini_file('/var/local/emhttp/disks.ini', true);
$shares = parse_ini_file('/var/local/emhttp/shares.ini', true);
$users = parse_ini_file('/var/local/emhttp/users.ini', true);
?>
```

## Disk Information ($disks)

When you need disk details, use `disks.ini`:

```php
<?
$disks = parse_ini_file('/var/local/emhttp/disks.ini', true);

foreach ($disks as $name => $disk) {
    // $name is 'parity', 'disk1', 'disk2', 'cache', etc.
    echo "{$name}: {$disk['device']} - {$disk['status']}\n";
    
    // Available properties per disk:
    // $disk['id']        - Disk identifier
    // $disk['device']    - Device name (sda, sdb, etc.)
    // $disk['status']    - DISK_OK, DISK_DSBL, etc.
    // $disk['temp']      - Temperature
    // $disk['size']      - Size in KB
    // $disk['fsSize']    - Filesystem size
    // $disk['fsFree']    - Free space
    // $disk['fsType']    - Filesystem type
}
?>
```

## Share Information ($shares)

```php
<?
$shares = parse_ini_file('/var/local/emhttp/shares.ini', true);

foreach ($shares as $name => $share) {
    echo "{$name}: {$share['free']} free of {$share['size']}\n";
    
    // Available properties:
    // $share['name']     - Share name
    // $share['free']     - Free space
    // $share['size']     - Total size
    // $share['fsType']   - Filesystem type
    // $share['include']  - Included disks
    // $share['exclude']  - Excluded disks
}
?>
```

## Notes

{: .warning }
> The `$var` array reflects point-in-time state. For rapidly changing values (like resync progress), re-read the file to get current values.

{: .note }
> Some properties may not exist depending on system configuration. Always use null coalescing or isset() checks.

## Related Topics

- [Dynamix Framework](../core/dynamix-framework.md)
- [File Path Reference](file-path-reference.md)
- [Array/Disk Access](../advanced/array-disk-access.md)
