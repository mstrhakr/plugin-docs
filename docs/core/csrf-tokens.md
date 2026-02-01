---
layout: default
title: CSRF Tokens
parent: Core Concepts
nav_order: 3
---

# CSRF Tokens

## Overview

Cross-Site Request Forgery (CSRF) protection is mandatory for all form submissions in Unraid. Every POST request must include a valid CSRF token to prevent malicious cross-site attacks.

## How CSRF Protection Works

1. Unraid generates a unique token per session
2. Token is stored in `$var['csrf_token']`
3. Forms include the token as a hidden field
4. Server validates token on every POST request
5. Invalid tokens result in request rejection

## Accessing the CSRF Token

### In PHP/Page Files

```php
<?
// The CSRF token is available in the global $var array
global $var;
$csrf_token = $var['csrf_token'];
?>
```

### Token Availability

The token is loaded from `/var/local/emhttp/var.ini` and is available in all page contexts where `$var` is initialized.

## Using CSRF Tokens in Forms

### Standard HTML Form

```html
<form method="POST" action="/update.php">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    <!-- Your form fields -->
    <input type="text" name="setting" value="<?=$cfg['setting']?>">
    <input type="submit" value="Save">
</form>
```

### Form with Target Frame

```html
<!-- Using Unraid's progress frame for background submission -->
<form method="POST" action="/update.php" target="progressFrame">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    <input type="text" name="setting" value="">
    <input type="submit" value="Apply">
</form>
```

## AJAX Requests

### jQuery POST

```javascript
// Include CSRF token in AJAX POST requests
$.post('/plugins/yourplugin/update.php', {
    csrf_token: '<?=$var["csrf_token"]?>',
    action: 'save',
    setting: $('#setting').val()
}, function(response) {
    // Handle response
});
```

### jQuery AJAX

```javascript
$.ajax({
    url: '/plugins/yourplugin/update.php',
    method: 'POST',
    data: {
        csrf_token: '<?=$var["csrf_token"]?>',
        action: 'update',
        value: newValue
    },
    success: function(response) {
        console.log('Success:', response);
    },
    error: function(xhr, status, error) {
        console.error('Error:', error);
    }
});
```

### Form Serialization

```javascript
// When serializing forms, ensure CSRF token is included
$('#myForm').on('submit', function(e) {
    e.preventDefault();
    
    // serialize() includes all form fields including hidden csrf_token
    $.post('/plugins/yourplugin/update.php', $(this).serialize(), function(response) {
        if (response.success) {
            location.reload();
        } else {
            swal('Error', response.message, 'error');
        }
    }, 'json');
});
```

### Fetch API

```javascript
// Using modern Fetch API
async function saveSettings() {
    const formData = new FormData();
    formData.append('csrf_token', '<?=$var["csrf_token"]?>');
    formData.append('setting', document.getElementById('setting').value);
    
    const response = await fetch('/plugins/yourplugin/update.php', {
        method: 'POST',
        body: formData
    });
    
    return await response.json();
}
```

## Server-Side Validation

### Basic Validation Pattern

```php
<?
// /plugins/yourplugin/update.php

// Load system variables to get valid CSRF token
$var = parse_ini_file('/var/local/emhttp/var.ini');

// Validate CSRF token
if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $var['csrf_token']) {
    // Token missing or invalid
    http_response_code(403);
    die("Security token validation failed");
}

// Token valid, proceed with processing
$setting = $_POST['setting'] ?? '';
// ... process the request
?>
```

### Validation with JSON Response

```php
<?
// /plugins/yourplugin/api.php

header('Content-Type: application/json');

$var = parse_ini_file('/var/local/emhttp/var.ini');

// Validate CSRF token
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $var['csrf_token']) {
        echo json_encode([
            'success' => false,
            'error' => 'Invalid security token. Please refresh the page.'
        ]);
        exit;
    }
}

// Process valid request
$action = $_POST['action'] ?? '';

switch ($action) {
    case 'save':
        // Save logic
        echo json_encode(['success' => true]);
        break;
    default:
        echo json_encode(['success' => false, 'error' => 'Unknown action']);
}
?>
```

### Reusable Validation Function

```php
<?
// /plugins/yourplugin/include/functions.php

/**
 * Validate CSRF token for POST requests
 * @param bool $dieOnFail Whether to terminate on failure
 * @return bool True if valid
 */
function validateCSRF($dieOnFail = true) {
    $var = parse_ini_file('/var/local/emhttp/var.ini');
    
    $isValid = isset($_POST['csrf_token']) && 
               $_POST['csrf_token'] === $var['csrf_token'];
    
    if (!$isValid && $dieOnFail) {
        http_response_code(403);
        die("CSRF validation failed");
    }
    
    return $isValid;
}

// Usage in your scripts
require_once "/usr/local/emhttp/plugins/yourplugin/include/functions.php";
validateCSRF();  // Dies if invalid
// ... safe to proceed
?>
```

## Token Refresh Patterns

### Page Reload Pattern

The simplest approach - reload the page after changes:

```javascript
$.post('/plugins/yourplugin/update.php', {
    csrf_token: '<?=$var["csrf_token"]?>',
    setting: value
}, function(response) {
    if (response.success) {
        // Reload gets fresh token
        location.reload();
    }
});
```

### Fetch New Token via AJAX

For single-page-app style interfaces that don't reload:

```php
<?
// /plugins/yourplugin/gettoken.php
// Returns fresh CSRF token (still validates session)

$var = parse_ini_file('/var/local/emhttp/var.ini');
header('Content-Type: application/json');
echo json_encode(['csrf_token' => $var['csrf_token']]);
?>
```

```javascript
// Client-side token refresh
async function refreshToken() {
    const response = await fetch('/plugins/yourplugin/gettoken.php');
    const data = await response.json();
    
    // Update all CSRF token fields on the page
    $('input[name="csrf_token"]').val(data.csrf_token);
    
    // Store for AJAX use
    window.csrfToken = data.csrf_token;
}

// Refresh token periodically or before submission
setInterval(refreshToken, 300000);  // Every 5 minutes
```

## Common Errors and Solutions

### "Invalid CSRF Token" Error

**Causes:**
1. Form missing CSRF token field
2. Session expired (user idle too long)
3. Page cached with old token
4. Multiple browser tabs with different tokens

**Solutions:**

```php
<!-- Ensure token field exists -->
<form method="POST">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    ...
</form>
```

```javascript
// Handle token expiration gracefully
$.post('/update.php', formData)
    .done(function(response) {
        // Success
    })
    .fail(function(xhr) {
        if (xhr.status === 403) {
            swal({
                title: 'Session Expired',
                text: 'Please refresh the page and try again.',
                type: 'warning'
            }, function() {
                location.reload();
            });
        }
    });
```

### Token Not Available

**Cause:** `$var` not initialized in your script.

**Solution:**

```php
<?
// Ensure $var is loaded
if (!isset($var)) {
    $var = parse_ini_file('/var/local/emhttp/var.ini');
}
$csrf_token = $var['csrf_token'];
?>
```

## Security Best Practices

1. **Never log or expose tokens** - Don't write CSRF tokens to log files
2. **Always validate on POST** - Check every state-changing request
3. **Use HTTPS** - Prevents token interception (Unraid supports SSL)
4. **Combine with authentication** - CSRF tokens complement, not replace, auth
5. **Don't include in URLs** - Keep tokens in POST body or headers, never GET parameters

## GET Requests

{: .note }
> GET requests don't require CSRF tokens because they should not modify state. If your action modifies data, use POST.

```php
<?
// WRONG - Don't modify state via GET
// /plugins/yourplugin/delete.php?id=123

// RIGHT - Use POST for state changes
// <form method="POST" action="/plugins/yourplugin/delete.php">
//     <input type="hidden" name="csrf_token" value="...">
//     <input type="hidden" name="id" value="123">
// </form>
?>
```

## Related Topics

- [Form Controls](../ui/form-controls.md)
- [JavaScript Patterns](../ui/javascript-patterns.md)
- [Input Validation](../security/input-validation.md)
