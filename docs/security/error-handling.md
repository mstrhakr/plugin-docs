---
layout: default
title: Error Handling
parent: Security & Best Practices
nav_order: 3
---

# Error Handling

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Good error handling improves user experience and makes debugging easier. This guide covers patterns for handling errors gracefully in Unraid plugins.

## Principles

1. **Fail gracefully** - Don't crash the entire page
2. **Log details** - Record full error info for debugging
3. **Show friendly messages** - Users see helpful, non-technical text
4. **Don't expose internals** - Hide paths, stack traces from users
5. **Provide next steps** - Tell users what to do

## PHP Error Handling

### Try-Catch Pattern

```php
<?
try {
    // Risky operation
    $result = performOperation();
    
    if (!$result) {
        throw new Exception("Operation failed");
    }
    
} catch (Exception $e) {
    // Log the real error
    syslog(LOG_ERR, "yourplugin: " . $e->getMessage());
    
    // Show user-friendly message
    $error = "An error occurred. Please check the logs for details.";
}
?>

<?if (isset($error)):?>
<p class="error"><?=htmlspecialchars($error)?></p>
<?endif;?>
```

### Custom Error Handler

```php
<?
function pluginErrorHandler($errno, $errstr, $errfile, $errline) {
    // Log full details
    $message = sprintf(
        "Error [%d]: %s in %s on line %d",
        $errno, $errstr, $errfile, $errline
    );
    syslog(LOG_ERR, "yourplugin: $message");
    
    // Don't execute PHP's internal error handler
    return true;
}

// Enable for your plugin code
set_error_handler("pluginErrorHandler");

// ... your code ...

// Restore default handler
restore_error_handler();
?>
```

### Checking Return Values

```php
<?
// File operations
$content = file_get_contents($file);
if ($content === false) {
    $error = "Failed to read configuration file";
    syslog(LOG_ERR, "yourplugin: Cannot read $file");
}

// Exec calls
exec("some_command 2>&1", $output, $retval);
if ($retval !== 0) {
    $error = "Command failed";
    syslog(LOG_ERR, "yourplugin: Command returned $retval: " . implode("\n", $output));
}
?>
```

## User-Friendly Messages

### Good vs Bad Error Messages

```php
<?
// BAD - Exposes internal details
$error = "MySQL error: SELECT * FROM table WHERE id=$id failed at /var/www/db.php:45";

// GOOD - User-friendly
$error = "Unable to load settings. Please try again or contact support.";

// BETTER - With action
$error = "Unable to load settings. <a href='settings.php?reload=1'>Click here to retry</a>.";
?>
```

### Error Message Patterns

```php
<?
$errorMessages = [
    'file_not_found' => "Configuration file not found. Please reinstall the plugin.",
    'permission_denied' => "Permission denied. Check file permissions.",
    'connection_failed' => "Could not connect to service. Is it running?",
    'invalid_input' => "Invalid input provided. Please check your settings.",
    'timeout' => "Operation timed out. Please try again.",
];

function getUserError($code) {
    global $errorMessages;
    return $errorMessages[$code] ?? "An unexpected error occurred.";
}
?>
```

## Bash Script Error Handling

```bash
#!/bin/bash

# Exit on error
set -e

# Error handler
error_handler() {
    logger -t "yourplugin" "Error on line $1"
    exit 1
}

trap 'error_handler $LINENO' ERR

# Check command success
if ! some_command; then
    logger -t "yourplugin" "some_command failed"
    exit 1
fi

# Check file exists
if [ ! -f "/path/to/required/file" ]; then
    logger -t "yourplugin" "Required file missing"
    exit 1
fi
```

## Validation Errors

```php
<?
$errors = [];

// Collect all validation errors
if (empty($_POST['name'])) {
    $errors[] = "Name is required";
}

if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
    $errors[] = "Invalid email address";
}

if ($_POST['port'] < 1 || $_POST['port'] > 65535) {
    $errors[] = "Port must be between 1 and 65535";
}

// Display all errors together
if (!empty($errors)):
?>
<div class="error-box">
    <p><strong>Please correct the following errors:</strong></p>
    <ul>
    <?foreach ($errors as $err):?>
        <li><?=htmlspecialchars($err)?></li>
    <?endforeach;?>
    </ul>
</div>
<?
endif;
?>
```

## AJAX Error Handling

### Server Side

```php
<?
header('Content-Type: application/json');

try {
    // Process request
    $result = doSomething();
    
    echo json_encode([
        'success' => true,
        'data' => $result
    ]);
    
} catch (Exception $e) {
    syslog(LOG_ERR, "yourplugin: " . $e->getMessage());
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Operation failed. Check logs for details.'
    ]);
}
?>
```

### Client Side

```javascript
$.ajax({
    url: '/plugins/yourplugin/action.php',
    method: 'POST',
    data: formData,
    success: function(response) {
        if (response.success) {
            swal('Success', 'Operation completed', 'success');
        } else {
            swal('Error', response.error, 'error');
        }
    },
    error: function(xhr, status, error) {
        var message = 'Request failed';
        try {
            var response = JSON.parse(xhr.responseText);
            message = response.error || message;
        } catch(e) {}
        
        swal('Error', message, 'error');
    }
});
```

## Logging Levels

```php
<?
// Use appropriate severity
syslog(LOG_DEBUG, "yourplugin: Debug info");     // Development only
syslog(LOG_INFO, "yourplugin: Informational");   // Normal operations
syslog(LOG_WARNING, "yourplugin: Warning");      // Potential issues
syslog(LOG_ERR, "yourplugin: Error");            // Errors
syslog(LOG_CRIT, "yourplugin: Critical");        // Critical failures
?>
```

## Recovery Patterns

```php
<?
// Retry logic
function withRetry($callback, $maxAttempts = 3, $delay = 1) {
    $lastException = null;
    
    for ($i = 0; $i < $maxAttempts; $i++) {
        try {
            return $callback();
        } catch (Exception $e) {
            $lastException = $e;
            sleep($delay);
        }
    }
    
    throw $lastException;
}

// Usage
try {
    $result = withRetry(function() {
        return fetchRemoteData();
    });
} catch (Exception $e) {
    $error = "Failed after multiple attempts";
}
?>
```

## Related Topics

- [Debugging Techniques]({% link docs/advanced/debugging-techniques.md %})
- [Notifications System]({% link docs/core/notifications-system.md %})
- [Input Validation]({% link docs/security/input-validation.md %})
