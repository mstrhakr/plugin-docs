---
layout: default
title: Plugin Settings Storage
parent: Core Concepts
nav_order: 5
---

# Plugin Settings Storage

## Overview

Plugins store their configuration in `.cfg` files located in `/boot/config/plugins/`. These files persist across reboots since `/boot/` is on the USB drive.

## File Locations

### Configuration Directory Structure

Organize your plugin's persistent files in a dedicated directory on the USB flash drive. The main config file should match your plugin name, with additional files for separate concerns like schedules or user-specific settings.

```
/boot/config/plugins/yourplugin/
├── yourplugin.cfg      # Main settings file (convention)
├── settings.cfg        # Additional settings (optional)
├── users.cfg           # User-specific settings (optional)
├── schedules.cfg       # Schedule configurations (optional)
└── custom/             # User customizations directory
    └── ...
```

### Naming Convention

The primary configuration file should match your plugin name:
- Plugin: `yourplugin`
- Config: `yourplugin.cfg`

## Configuration File Format

Configuration files use a simple `key="value"` format compatible with both Bash `source` and PHP's `parse_ini_file()`. Always quote values, even simple ones, for consistency and to handle special characters properly.

```ini
# /boot/config/plugins/yourplugin/yourplugin.cfg
# Comments start with #

enabled="yes"
interval="60"
path="/mnt/user/appdata"
notify_level="warning"
custom_message="Hello \"World\""
multiword="value with spaces"
```

### Format Rules

1. **Keys**: Alphanumeric and underscores, no spaces
2. **Values**: Enclosed in double quotes
3. **Escaping**: Use `\"` for quotes inside values
4. **Comments**: Lines starting with `#` are ignored
5. **Empty lines**: Allowed and ignored

## The parse_plugin_cfg() Function

Unraid provides a built-in function to read plugin configuration files.

### Basic Usage

```php
<?
// Reads /boot/config/plugins/yourplugin/yourplugin.cfg
$cfg = parse_plugin_cfg("yourplugin");

// Access settings
$enabled = $cfg['enabled'] ?? 'no';
$interval = $cfg['interval'] ?? '60';
$path = $cfg['path'] ?? '/mnt/user/appdata';
?>
```

### Function Internals

The `parse_plugin_cfg()` function:
1. Constructs path: `/boot/config/plugins/{name}/{name}.cfg`
2. Returns empty array if file doesn't exist
3. Parses file using `parse_ini_file()` 
4. Returns associative array of settings

### With Alternate Filename

```php
<?
// Read a different config file
$path = "/boot/config/plugins/yourplugin/custom.cfg";
if (file_exists($path)) {
    $custom_cfg = parse_ini_file($path);
}
?>
```

## Reading Configuration

### With `default.cfg` (Recommended Pattern)

```php
<?
// Keep defaults in:
// /usr/local/emhttp/plugins/yourplugin/default.cfg
// parse_plugin_cfg() merges defaults with user config automatically.
$cfg = parse_plugin_cfg("yourplugin");

// $cfg already includes defaults for any missing keys.
$enabled = $cfg['enabled'] === 'yes';
$interval = intval($cfg['interval']);
?>
```

```ini
# /usr/local/emhttp/plugins/yourplugin/default.cfg
enabled="no"
interval="60"
path="/mnt/user/appdata"
notify_level="normal"
```

{: .note }
> Keep defaults in `default.cfg` (under `/usr/local/emhttp/plugins/<plugin>/`) instead of recreating default values in each PHP script.

### Type-Safe Access

```php
<?
$cfg = parse_plugin_cfg("yourplugin");

// Boolean conversion
$enabled = ($cfg['enabled'] ?? 'no') === 'yes';

// Integer conversion
$interval = intval($cfg['interval'] ?? '60');

// With validation
$path = $cfg['path'] ?? '/mnt/user/appdata';
if (!is_dir($path)) {
    $path = '/mnt/user/appdata';  // Fallback
}
?>
```

## Writing Configuration

When handling form submissions or AJAX writes, validate the CSRF token before saving settings. See [CSRF Tokens](csrf-tokens.md) for the full pattern and background.

### Basic Write Pattern

```php
<?
// /plugins/yourplugin/update.php

function save_plugin_cfg($plugin, $settings) {
    $cfg_file = "/boot/config/plugins/$plugin/$plugin.cfg";
    $config = "";

    foreach ($settings as $key => $value) {
        $config .= "$key=\"$value\"\n";
    }

    return file_put_contents($cfg_file, $config) !== false;
}

// Validate CSRF
$var = parse_ini_file('/var/local/emhttp/var.ini');
if ($_POST['csrf_token'] !== $var['csrf_token']) {
    die("Invalid CSRF token");
}

// Use the helper
save_plugin_cfg("yourplugin", [
    'enabled' => $_POST['enabled'],
    'interval' => $_POST['interval'],
    'path' => $_POST['path']
]);
?>
```

### With Sanitization (Recommended)

```php
<?
// /plugins/yourplugin/update.php

/**
 * Escape value for INI file
 */
function escapeIniValue($value) {
    // Escape special characters
    $value = str_replace('\\', '\\\\', $value);
    $value = str_replace('"', '\\"', $value);
    return $value;
}

function save_plugin_cfg($plugin, $settings) {
    $cfg_file = "/boot/config/plugins/$plugin/$plugin.cfg";

    $config = "";
    foreach ($settings as $key => $value) {
        $key = preg_replace('/[^a-zA-Z0-9_]/', '', $key);
        $config .= "$key=\"" . escapeIniValue($value) . "\"\n";
    }

    $dir = dirname($cfg_file);
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }

    $temp_file = $cfg_file . '.tmp';
    if (file_put_contents($temp_file, $config) !== false) {
        return rename($temp_file, $cfg_file);
    }

    return false;
}

$var = parse_ini_file('/var/local/emhttp/var.ini');
if ($_POST['csrf_token'] !== $var['csrf_token']) {
    die("Invalid CSRF token");
}

// Sanitize and validate inputs
$enabled = in_array($_POST['enabled'], ['yes', 'no']) ? $_POST['enabled'] : 'no';
$interval = max(1, min(3600, intval($_POST['interval'])));  // 1-3600 range
$path = trim($_POST['path']);

save_plugin_cfg("yourplugin", [
    'enabled' => $enabled,
    'interval' => $interval,
    'path' => $path
]);
?>
```

### Using Helper Function

```php
<?
/**
 * Save plugin configuration
 * 
 * @param string $plugin Plugin name
 * @param array $settings Key-value pairs to save
 * @return bool Success
 */
function save_plugin_cfg($plugin, $settings) {
    $cfg_file = "/boot/config/plugins/$plugin/$plugin.cfg";
    $dir = dirname($cfg_file);
    
    // Ensure directory exists
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }
    
    // Build config content
    $config = "";
    foreach ($settings as $key => $value) {
        // Sanitize key (alphanumeric and underscore only)
        $key = preg_replace('/[^a-zA-Z0-9_]/', '', $key);
        // Escape value
        $value = str_replace(['\\', '"'], ['\\\\', '\\"'], $value);
        $config .= "$key=\"$value\"\n";
    }
    
    // Atomic write
    $temp = $cfg_file . '.tmp';
    if (file_put_contents($temp, $config) !== false) {
        return rename($temp, $cfg_file);
    }
    return false;
}

// Usage
save_plugin_cfg("yourplugin", [
    'enabled' => $_POST['enabled'],
    'interval' => $_POST['interval'],
    'path' => $_POST['path']
]);
?>
```

## Default File Strategy

Use two files with clear responsibilities:

- `/usr/local/emhttp/plugins/yourplugin/default.cfg` for shipped defaults
- `/boot/config/plugins/yourplugin/yourplugin.cfg` for user overrides

`parse_plugin_cfg("yourplugin")` handles merging, so you do not need to rewrite defaults at runtime.

### Shipping `default.cfg` in Your Package

Install `default.cfg` as part of your plugin package so it is available in `/usr/local/emhttp/plugins/yourplugin/`.

```ini
# /usr/local/emhttp/plugins/yourplugin/default.cfg
enabled="no"
interval="60"
path="/mnt/user/appdata"
notify_level="normal"
```

### Writing Only User Changes

When saving settings, write only values the user changed into `yourplugin.cfg`.

```php
<?
$cfg = parse_plugin_cfg("yourplugin");

// Update only user-editable values
$cfg['enabled'] = $_POST['enabled'];
$cfg['interval'] = strval(max(1, min(3600, intval($_POST['interval']))));

save_plugin_cfg("yourplugin", $cfg);
?>
```

## Migration Patterns

### Version Migration

Handle settings changes between plugin versions:

```php
<?
$cfg_file = "/boot/config/plugins/yourplugin/yourplugin.cfg";
$cfg = parse_plugin_cfg("yourplugin");

// Check if migration needed
$config_version = $cfg['config_version'] ?? '1';

if ($config_version < '2') {
    // Migrate from v1 to v2
    // Rename old setting
    if (isset($cfg['old_setting'])) {
        $cfg['new_setting'] = $cfg['old_setting'];
        unset($cfg['old_setting']);
    }
    
    // Add new required setting
    $cfg['new_feature'] = $cfg['new_feature'] ?? 'enabled';
    
    // Update version
    $cfg['config_version'] = '2';
    
    // Save migrated config
    save_plugin_cfg("yourplugin", $cfg);
}

if ($config_version < '3') {
    // Migrate from v2 to v3
    // ... additional migrations
    $cfg['config_version'] = '3';
    save_plugin_cfg("yourplugin", $cfg);
}
?>
```

### Backup Before Migration

```php
<?
function migrateConfig($plugin, $fromVersion, $migrationFn) {
    $cfg_file = "/boot/config/plugins/$plugin/$plugin.cfg";
    
    // Backup current config
    $backup = $cfg_file . ".v$fromVersion.bak";
    if (!file_exists($backup)) {
        copy($cfg_file, $backup);
    }
    
    // Run migration
    $cfg = parse_plugin_cfg($plugin);
    $cfg = $migrationFn($cfg);
    save_plugin_cfg($plugin, $cfg);
}
?>
```

## Multiple Configuration Files

### Separate Files by Purpose

```php
<?
$plugin = "yourplugin";
$base = "/boot/config/plugins/$plugin";

// Main settings
$main_cfg = parse_plugin_cfg($plugin);

// User-specific settings
$users_cfg = file_exists("$base/users.cfg") 
    ? parse_ini_file("$base/users.cfg", true) 
    : [];

// Schedule settings (array of schedules)
$schedules_cfg = file_exists("$base/schedules.cfg")
    ? parse_ini_file("$base/schedules.cfg", true)
    : [];
?>
```

### INI Sections

For complex configurations, use INI sections:

```ini
# /boot/config/plugins/yourplugin/advanced.cfg

[general]
enabled="yes"
debug="no"

[schedule]
interval="daily"
time="03:00"

[notifications]
email="yes"
pushover="no"
```

```php
<?
// true = parse sections into nested arrays
$cfg = parse_ini_file("/boot/config/plugins/yourplugin/advanced.cfg", true);

$enabled = $cfg['general']['enabled'];
$schedule_time = $cfg['schedule']['time'];
$email_notify = $cfg['notifications']['email'];
?>
```

## Best Practices

1. **Use `default.cfg` for defaults** - Let `parse_plugin_cfg()` merge defaults and user overrides
2. **Validate before writing** - Sanitize all user input
3. **Use atomic writes** - Write to temp file, then rename
4. **Escape values properly** - Handle quotes and special characters
5. **Version your config format** - Track schema changes for migrations
6. **Backup before migration** - Preserve user settings when upgrading
7. **Use consistent naming** - `plugin.cfg` matches plugin name
8. **Document settings** - Keep comments and rationale in `default.cfg`

## Related Topics

- [Input Validation](../security/input-validation.md)
- [File System Layout](../filesystem.md)
- [Form Controls](../ui/form-controls.md)
- [PLG File Reference](../plg-file.md)
