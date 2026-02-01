---
layout: default
title: PHP Functions Reference
parent: Reference
nav_order: 1
---

# PHP Functions Reference

{: .note }
> ✅ **Validated against Unraid 7.2.3** - Function locations and implementations verified.

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

This reference documents PHP functions available in the Unraid environment that are useful for plugin development.

## Configuration Functions

### parse_plugin_cfg()

Reads plugin configuration from `.cfg` files.

```php
<?
$cfg = parse_plugin_cfg("yourplugin");
// Reads from /boot/config/plugins/yourplugin/yourplugin.cfg

$setting = $cfg['setting_name'] ?? 'default';
?>
```

**Parameters:**
- `$plugin` (string) - Plugin name

**Returns:**
- Array of key-value pairs from the config file

### parse_ini_file()

Standard PHP function for reading INI files.

```php
<?
// Read Unraid state files
$disks = parse_ini_file('/var/local/emhttp/disks.ini', true);
$shares = parse_ini_file('/var/local/emhttp/shares.ini', true);
$var = parse_ini_file('/var/local/emhttp/var.ini');
?>
```

## Translation Functions

### _()

Returns translated string.

```php
<?
echo _("Hello World");
echo sprintf(_("Welcome, %s"), $username);
?>
```

**Parameters:**
- `$text` (string) - Text to translate

**Returns:**
- Translated string or original if no translation exists

## Global Variables

### $var

System variables and state.

```php
<?
global $var;

$var['csrf_token'];    // CSRF token for forms
$var['fsState'];       // Array state (Started, Stopped)
$var['mdState'];       // MD device state
$var['version'];       // Unraid version
?>
```

### $Dynamix

Dynamix framework settings.

```php
<?
global $Dynamix;

// TODO: Document available properties
// $Dynamix['theme']
// $Dynamix['display']
?>
```

## Notification Functions

### notify (shell)

Send notifications via shell command.

```php
<?
exec("/usr/local/emhttp/webGui/scripts/notify " .
     "-e " . escapeshellarg("Event") . " " .
     "-s " . escapeshellarg("Subject") . " " .
     "-d " . escapeshellarg("Description") . " " .
     "-i " . escapeshellarg("normal"));
?>
```

## nchan Functions

### nchan_publish() (if available)

TODO: Document nchan publishing function

```php
<?
// Publish to nchan channel
nchan_publish('channel_name', json_encode($data));
?>
```

## File Helpers

### my_scale_filesize()

TODO: Document if this function exists

```php
<?
// Format file size for display
$formatted = my_scale_filesize($bytes);
?>
```

### my_number()

TODO: Document if this function exists

```php
<?
// Format number with locale
$formatted = my_number($value);
?>
```

## Path Helpers

### Common Path Functions

```php
<?
// Get plugin directory
$pluginDir = "/usr/local/emhttp/plugins/yourplugin";

// Get config directory
$configDir = "/boot/config/plugins/yourplugin";

// Check if path is on array
function isOnArray($path) {
    return strpos($path, '/mnt/disk') === 0 || 
           strpos($path, '/mnt/user') === 0 ||
           strpos($path, '/mnt/cache') === 0;
}
?>
```

## Docker Functions

TODO: Document any Unraid-specific Docker helpers

## Network Functions

TODO: Document network-related helpers

## Array/Disk Functions

TODO: Document array and disk helper functions

```php
<?
// Example placeholders
// function is_array_started()
// function get_disk_info($disk)
// function get_share_info($share)
?>
```

## Included Libraries

Libraries available in the Unraid PHP environment:

| Library | Purpose |
|---------|---------|
| TODO | Document included libraries |

## Standard PHP Functions

These standard PHP functions are commonly used:

| Function | Purpose |
|----------|---------|
| `file_get_contents()` | Read file contents |
| `file_put_contents()` | Write file contents |
| `exec()` | Execute shell command |
| `shell_exec()` | Execute and return output |
| `json_encode()` / `json_decode()` | JSON handling |
| `htmlspecialchars()` | HTML escaping |
| `escapeshellarg()` | Shell argument escaping |

## Related Topics

- [Dynamix Framework]({% link docs/core/dynamix-framework.md %})
- [Plugin Settings Storage]({% link docs/core/plugin-settings-storage.md %})
- [Multi-language Support]({% link docs/core/multi-language-support.md %})
