---
layout: default
title: User Scripts Integration
parent: Advanced Topics
nav_order: 3
---

# User Scripts Integration

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

The [User Scripts](https://forums.unraid.net/topic/48286-plugin-user-scripts/) plugin by Squid is widely used for running custom scripts. Your plugin can integrate with or complement User Scripts functionality.

## User Scripts Location

```
/boot/config/plugins/user.scripts/scripts/
└── MyScript/
    ├── script          # The actual script
    ├── name            # Display name
    ├── description     # Script description
    └── schedule        # Cron schedule (optional)
```

## Creating Compatible Scripts

### Script Format

```bash
#!/bin/bash
#name=My Script Name
#description=What this script does
#arrayStarted=true

# Your script code here
echo "Running my script..."
```

### Script Headers

| Header | Description |
|--------|-------------|
| `#name=` | Display name in UI |
| `#description=` | Description shown in UI |
| `#arrayStarted=true` | Only run when array started |
| `#noParity=true` | Don't run during parity check |

## Programmatic Integration

### List User Scripts

```php
<?
$scriptsDir = '/boot/config/plugins/user.scripts/scripts/';
$scripts = [];

if (is_dir($scriptsDir)) {
    foreach (glob("$scriptsDir/*/script") as $scriptPath) {
        $dir = dirname($scriptPath);
        $name = basename($dir);
        
        $scripts[$name] = [
            'path' => $scriptPath,
            'name' => file_exists("$dir/name") ? trim(file_get_contents("$dir/name")) : $name,
            'description' => file_exists("$dir/description") ? trim(file_get_contents("$dir/description")) : ''
        ];
    }
}
?>
```

### Run a User Script

```php
<?
function runUserScript($scriptName) {
    $scriptPath = "/boot/config/plugins/user.scripts/scripts/$scriptName/script";
    
    if (!file_exists($scriptPath)) {
        return ['success' => false, 'error' => 'Script not found'];
    }
    
    exec("bash " . escapeshellarg($scriptPath) . " 2>&1", $output, $retval);
    
    return [
        'success' => $retval === 0,
        'output' => implode("\n", $output)
    ];
}
?>
```

## Installing Scripts via Plugin

### Via PLG FILE

```xml
<FILE Name="/boot/config/plugins/user.scripts/scripts/MyPluginScript/script" Mode="0755">
<INLINE>
#!/bin/bash
#name=My Plugin Script
#description=Script installed by My Plugin

# Script content
echo "Hello from My Plugin"
</INLINE>
</FILE>

<FILE Name="/boot/config/plugins/user.scripts/scripts/MyPluginScript/name">
<INLINE>
My Plugin Script
</INLINE>
</FILE>
```

## Checking if User Scripts is Installed

```php
<?
function isUserScriptsInstalled() {
    return is_dir('/boot/config/plugins/user.scripts/');
}

if (isUserScriptsInstalled()) {
    // Offer User Scripts integration
}
?>
```

## Schedule Integration

User Scripts can run on schedules. If your plugin needs similar functionality, consider:

1. Adding scripts to User Scripts (easier for users)
2. Using your own cron jobs (more control)
3. Both options for flexibility

## Background Script Execution

User Scripts runs scripts in background with logging:

```bash
# Scripts output is logged to:
/tmp/user.scripts/tmpScripts/ScriptName/log.txt
```

## Complementing User Scripts

Instead of duplicating functionality:

- Link to User Scripts for simple scheduling needs
- Provide pre-made scripts users can copy
- Offer export to User Scripts format

## Related Topics

- [Cron Jobs]({% link docs/core/cron-jobs.md %})
- [rc.d Scripts]({% link docs/core/rc-d-scripts.md %})
- [Event System]({% link docs/events.md %})

## References

- [User Scripts Forum Thread](https://forums.unraid.net/topic/48286-plugin-user-scripts/)
- [User Scripts GitHub](https://github.com/Squidly271/user.scripts)
