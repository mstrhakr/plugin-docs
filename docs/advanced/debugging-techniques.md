---
layout: default
title: Debugging Techniques
parent: Advanced Topics
nav_order: 4
---

# Debugging Techniques

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Effective debugging is essential for plugin development. This guide covers logging, error handling, and tools for troubleshooting Unraid plugins.

{: .placeholder-image }
> 📷 **Screenshot needed:** *Browser DevTools open on an Unraid plugin page, showing the Console and Network tabs for debugging*
>
> ![Browser DevTools](../../assets/images/screenshots/browser-devtools.png)

## Logging

### Using logger (syslog)

```bash
#!/bin/bash
# Log to syslog
logger -t "yourplugin" "This is a log message"
logger -t "yourplugin" -p local7.error "This is an error"
```

### PHP Logging

```php
<?
// Log to syslog
openlog("yourplugin", LOG_PID, LOG_LOCAL7);
syslog(LOG_INFO, "Plugin started");
syslog(LOG_ERR, "An error occurred");
closelog();

// Simple file logging
function pluginLog($message, $level = 'INFO') {
    $logFile = '/var/log/yourplugin.log';
    $timestamp = date('Y-m-d H:i:s');
    file_put_contents($logFile, "[$timestamp] [$level] $message\n", FILE_APPEND);
}

pluginLog("Operation completed");
pluginLog("Something went wrong", "ERROR");
?>
```

### Viewing Logs

```bash
# View syslog
tail -f /var/log/syslog | grep yourplugin

# View specific log file
tail -f /var/log/yourplugin.log

# View all recent logs
dmesg | tail -50
```

{: .placeholder-image }
> 📷 **Screenshot needed:** *Terminal showing syslog output with plugin log messages highlighted*
>
> ![Syslog output](../../assets/images/screenshots/syslog-plugin-output.png)

## PHP Error Handling

### Display Errors (Development Only)

```php
<?
// At the top of your page file (remove in production!)
ini_set('display_errors', 1);
error_reporting(E_ALL);
?>
```

### Try-Catch Blocks

```php
<?
try {
    // Risky operation
    $result = someFunctionThatMightFail();
} catch (Exception $e) {
    // Log the error
    pluginLog("Exception: " . $e->getMessage(), "ERROR");
    
    // Show user-friendly message
    echo "<p class='error'>An error occurred. Check logs for details.</p>";
}
?>
```

### Custom Error Handler

```php
<?
function pluginErrorHandler($errno, $errstr, $errfile, $errline) {
    $message = "Error [$errno]: $errstr in $errfile on line $errline";
    pluginLog($message, "ERROR");
    return false; // Let PHP handle it too
}

set_error_handler("pluginErrorHandler");
?>
```

## Browser Developer Tools

### Console Logging

```javascript
// Debug JavaScript
console.log('Debug info:', variable);
console.warn('Warning message');
console.error('Error message');
console.table(arrayOrObject); // Nice table format
```

### Network Tab

- Monitor AJAX requests
- Check response codes
- View request/response data
- Identify slow requests

### Debugging AJAX

```javascript
$.ajax({
    url: '/plugins/yourplugin/action.php',
    method: 'POST',
    data: { action: 'test' },
    success: function(response) {
        console.log('Success:', response);
    },
    error: function(xhr, status, error) {
        console.error('Error:', status, error);
        console.log('Response:', xhr.responseText);
    }
});
```

## Command Line Debugging

### Test PHP Scripts

```bash
# Run PHP directly
php /usr/local/emhttp/plugins/yourplugin/test.php

# Check PHP syntax
php -l /usr/local/emhttp/plugins/yourplugin/file.php
```

### Test Bash Scripts

```bash
# Run with debug output
bash -x /path/to/script.sh

# Check syntax
bash -n /path/to/script.sh
```

## Common Issues

### Permission Problems

```bash
# Check file permissions
ls -la /usr/local/emhttp/plugins/yourplugin/

# Fix permissions
chmod 755 /usr/local/emhttp/plugins/yourplugin/scripts/*.sh
```

### Path Issues

```php
<?
// Always use absolute paths
$path = '/usr/local/emhttp/plugins/yourplugin/data.txt';

// Debug path issues
if (!file_exists($path)) {
    pluginLog("File not found: $path");
}
?>
```

### CSRF Token Issues

```php
<?
// Debug CSRF
global $var;
pluginLog("CSRF Token: " . $var['csrf_token']);
pluginLog("POST Token: " . ($_POST['csrf_token'] ?? 'missing'));
?>
```

## Debug Mode Toggle

```php
<?
// Add debug mode to your plugin
$cfg = parse_plugin_cfg('yourplugin');
$debugMode = ($cfg['debug'] ?? 'no') === 'yes';

function debug($message) {
    global $debugMode;
    if ($debugMode) {
        pluginLog("[DEBUG] $message");
    }
}

debug("This only logs when debug mode is enabled");
?>
```

## Helpful Commands

```bash
# Watch for file changes
inotifywait -m /usr/local/emhttp/plugins/yourplugin/

# Monitor resource usage
htop

# Check running processes
ps aux | grep yourplugin

# Network debugging
netstat -tlnp | grep LISTEN
```

## Related Topics

- [Error Handling]({% link docs/security/error-handling.md %})
- [Notifications System]({% link docs/core/notifications-system.md %})
