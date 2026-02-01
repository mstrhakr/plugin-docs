---
layout: default
title: Plugin Settings Storage
parent: Core Concepts
nav_order: 5
---

# Plugin Settings Storage

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Plugins store their configuration in `.cfg` files located in `/boot/config/plugins/`. These files persist across reboots since `/boot/` is on the USB drive.

## File Location

```
/boot/config/plugins/yourplugin/
├── yourplugin.cfg      # Main settings file
├── settings.cfg        # Additional settings
└── ...
```

## The parse_plugin_cfg() Function

```php
<?
// Read plugin configuration
$cfg = parse_plugin_cfg("yourplugin");

// Access settings
$setting = $cfg['setting_name'] ?? 'default_value';
?>
```

## Configuration File Format

```ini
# /boot/config/plugins/yourplugin/yourplugin.cfg
setting_name="value"
another_setting="another value"
numeric_setting="42"
```

## Writing Configuration

TODO: Document the proper way to save configuration

```php
<?
// Example: Saving settings
$cfg_file = "/boot/config/plugins/yourplugin/yourplugin.cfg";

// Build config content
$config = "setting_name=\"{$_POST['setting_name']}\"\n";
$config .= "another_setting=\"{$_POST['another_setting']}\"\n";

// Write to file
file_put_contents($cfg_file, $config);
?>
```

## Default Values

TODO: Document patterns for handling defaults

```php
<?
$cfg = parse_plugin_cfg("yourplugin");

// With defaults
$defaults = [
    'enabled' => 'no',
    'interval' => '60',
    'path' => '/mnt/user/appdata'
];

$settings = array_merge($defaults, $cfg);
?>
```

## Best Practices

- Always provide sensible defaults
- Validate values when reading
- Sanitize input before writing
- Use descriptive setting names

## Related Topics

- [Input Validation]({% link docs/security/input-validation.md %})
- [File System Layout]({% link docs/filesystem.md %})
- [Form Controls]({% link docs/ui/form-controls.md %})
