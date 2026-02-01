---
layout: default
title: Input Validation
parent: Security & Best Practices
nav_order: 1
---

# Input Validation

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Proper input validation is critical for plugin security. All user input must be validated, sanitized, and escaped appropriately to prevent security vulnerabilities.

## General Principles

1. **Never trust user input** - Always validate
2. **Whitelist over blacklist** - Accept known-good values
3. **Validate on input** - Check data when received
4. **Escape on output** - Escape data when displaying
5. **Use prepared statements** - For any database queries

## Validating POST Data

```php
<?
// Always check CSRF first
if ($_POST['csrf_token'] !== $var['csrf_token']) {
    die("Invalid request");
}

// Validate required fields
$required = ['name', 'path', 'option'];
foreach ($required as $field) {
    if (empty($_POST[$field])) {
        die("Missing required field: $field");
    }
}

// Type validation
$port = filter_input(INPUT_POST, 'port', FILTER_VALIDATE_INT);
if ($port === false || $port < 1 || $port > 65535) {
    die("Invalid port number");
}

$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
if ($email === false) {
    die("Invalid email address");
}
?>
```

## Path Validation

```php
<?
function validatePath($path) {
    // Normalize path
    $path = realpath($path);
    
    // Check for null (path doesn't exist)
    if ($path === false) {
        return false;
    }
    
    // Allowed base paths
    $allowed = [
        '/mnt/user/',
        '/mnt/cache/',
        '/boot/config/plugins/yourplugin/'
    ];
    
    foreach ($allowed as $base) {
        if (strpos($path, $base) === 0) {
            return $path;
        }
    }
    
    return false;
}

$userPath = $_POST['path'];
$safePath = validatePath($userPath);

if (!$safePath) {
    die("Invalid path");
}
?>
```

## Preventing Directory Traversal

```php
<?
// DANGEROUS - don't do this
$file = $_GET['file'];
include("/path/to/files/$file"); // Can include ../../../etc/passwd

// SAFE - validate and sanitize
$file = basename($_GET['file']); // Remove directory components
$allowed = ['config.php', 'settings.php', 'data.php'];

if (!in_array($file, $allowed)) {
    die("Invalid file");
}

include("/path/to/files/$file");
?>
```

## Escaping Output

### HTML Output

```php
<?
// Always escape when outputting to HTML
$username = $_POST['username'];

// DANGEROUS
echo "Hello, $username";

// SAFE
echo "Hello, " . htmlspecialchars($username, ENT_QUOTES, 'UTF-8');

// Helper function
function esc($string) {
    return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
}

echo "Hello, " . esc($username);
?>
```

### Shell Commands

```php
<?
// DANGEROUS
$filename = $_POST['filename'];
exec("cat $filename");

// SAFE
$filename = $_POST['filename'];
exec("cat " . escapeshellarg($filename));

// Even safer - validate first
$filename = basename($_POST['filename']);
$fullPath = "/safe/directory/$filename";
if (file_exists($fullPath)) {
    exec("cat " . escapeshellarg($fullPath));
}
?>
```

### JavaScript Output

```php
<script>
// DANGEROUS
var data = '<?=$_POST["data"]?>';

// SAFE
var data = <?=json_encode($_POST["data"])?>;
</script>
```

## String Validation

```php
<?
// Alphanumeric only
function isAlphanumeric($string) {
    return preg_match('/^[a-zA-Z0-9]+$/', $string);
}

// Slug format (lowercase, hyphens)
function isSlug($string) {
    return preg_match('/^[a-z0-9-]+$/', $string);
}

// IP address
function isValidIP($ip) {
    return filter_var($ip, FILTER_VALIDATE_IP) !== false;
}

// URL
function isValidURL($url) {
    return filter_var($url, FILTER_VALIDATE_URL) !== false;
}
?>
```

## Numeric Validation

```php
<?
// Integer in range
function validateInt($value, $min, $max) {
    $int = filter_var($value, FILTER_VALIDATE_INT);
    if ($int === false) return false;
    return ($int >= $min && $int <= $max) ? $int : false;
}

$port = validateInt($_POST['port'], 1, 65535);
$percentage = validateInt($_POST['percent'], 0, 100);
?>
```

## Dropdown/Select Validation

```php
<?
// Only accept known values
$validOptions = ['option1', 'option2', 'option3'];
$selected = $_POST['option'];

if (!in_array($selected, $validOptions)) {
    die("Invalid option selected");
}
?>
```

## File Upload Validation

```php
<?
// Validate file uploads carefully
$allowed_types = ['image/jpeg', 'image/png'];
$max_size = 5 * 1024 * 1024; // 5MB

if ($_FILES['upload']['error'] !== UPLOAD_ERR_OK) {
    die("Upload error");
}

if ($_FILES['upload']['size'] > $max_size) {
    die("File too large");
}

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $_FILES['upload']['tmp_name']);
finfo_close($finfo);

if (!in_array($mime, $allowed_types)) {
    die("Invalid file type");
}

// Safe filename
$filename = preg_replace('/[^a-zA-Z0-9._-]/', '', basename($_FILES['upload']['name']));
?>
```

## Common Vulnerabilities to Prevent

| Vulnerability | Prevention |
|---------------|------------|
| XSS | Escape HTML output with `htmlspecialchars()` |
| Command Injection | Use `escapeshellarg()` and validate input |
| Path Traversal | Use `basename()` and validate paths |
| CSRF | Always verify CSRF tokens |
| SQL Injection | Use prepared statements (if using databases) |

## Related Topics

- [CSRF Tokens]({% link docs/core/csrf-tokens.md %})
- [Error Handling]({% link docs/security/error-handling.md %})
- [Plugin Settings Storage]({% link docs/core/plugin-settings-storage.md %})
