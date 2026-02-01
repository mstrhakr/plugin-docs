---
layout: default
title: File Permissions
parent: Security & Best Practices
nav_order: 2
---

# File Permissions

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Correct file permissions are essential for security and proper plugin operation. This guide covers permission settings for different types of plugin files.

## Permission Basics

```
Owner  Group  Others
rwx    rwx    rwx
421    421    421

7 = rwx (read + write + execute)
6 = rw- (read + write)
5 = r-x (read + execute)
4 = r-- (read only)
0 = --- (no permissions)
```

## Recommended Permissions

### Executable Scripts

```bash
chmod 755 /usr/local/emhttp/plugins/yourplugin/scripts/*.sh
# rwxr-xr-x - Owner can do everything, others can read/execute
```

### Configuration Files

```bash
chmod 600 /boot/config/plugins/yourplugin/*.cfg
# rw------- - Only owner can read/write
```

### PHP Files

```bash
chmod 644 /usr/local/emhttp/plugins/yourplugin/*.php
# rw-r--r-- - Owner read/write, others read only
```

### Page Files

```bash
chmod 644 /usr/local/emhttp/plugins/yourplugin/*.page
# rw-r--r-- - Owner read/write, others read only
```

### Directories

```bash
chmod 755 /usr/local/emhttp/plugins/yourplugin/
# rwxr-xr-x - Owner full access, others can list and access
```

## Setting Permissions in PLG

### FILE Element Mode Attribute

```xml
<FILE Name="/usr/local/emhttp/plugins/yourplugin/script.sh" Mode="0755">
<INLINE>
#!/bin/bash
echo "Hello"
</INLINE>
</FILE>

<FILE Name="/boot/config/plugins/yourplugin/config.cfg" Mode="0600">
<INLINE>
password="secret"
</INLINE>
</FILE>
```

### Post-Install Permission Fix

```xml
<FILE Run="/bin/bash" Method="install">
<INLINE>
# Fix permissions
chmod 755 /usr/local/emhttp/plugins/yourplugin/scripts/*
chmod 644 /usr/local/emhttp/plugins/yourplugin/*.php
chmod 600 /boot/config/plugins/yourplugin/*.cfg
</INLINE>
</FILE>
```

## Common File Types and Permissions

| File Type | Permission | Octal | Notes |
|-----------|------------|-------|-------|
| Shell scripts | `rwxr-xr-x` | 755 | Must be executable |
| PHP files | `rw-r--r--` | 644 | Web server reads |
| Page files | `rw-r--r--` | 644 | Web server reads |
| Config files | `rw-------` | 600 | Sensitive data |
| Config files (shared) | `rw-r--r--` | 644 | If not sensitive |
| Directories | `rwxr-xr-x` | 755 | Allow traversal |
| Sensitive dirs | `rwx------` | 700 | Restrict access |
| Log files | `rw-r--r--` | 644 | Usually readable |
| PID files | `rw-r--r--` | 644 | Process tracking |

## Ownership

Files in Unraid typically run as root. When creating files programmatically:

```php
<?
// Create file with specific permissions
$file = '/path/to/file';
file_put_contents($file, $content);
chmod($file, 0644);

// For directories
mkdir('/path/to/dir', 0755, true);
?>
```

## Security Considerations

### Sensitive Files

Keep credentials and sensitive data secure:

```bash
# API keys, passwords, etc.
chmod 600 /boot/config/plugins/yourplugin/credentials.cfg
```

### World-Writable Files

**Avoid world-writable files (xx7, xx6, xx2)**

```bash
# BAD - anyone can modify
chmod 777 /path/to/file

# GOOD - only owner can write
chmod 755 /path/to/file
```

### Temporary Files

```bash
# Create temp files securely
TMPFILE=$(mktemp /tmp/yourplugin.XXXXXX)
chmod 600 "$TMPFILE"

# Clean up when done
rm -f "$TMPFILE"
```

## Checking Permissions

```bash
# List with permissions
ls -la /usr/local/emhttp/plugins/yourplugin/

# Find insecure files
find /usr/local/emhttp/plugins/yourplugin/ -perm -002 -type f

# Find world-writable directories
find /boot/config/plugins/yourplugin/ -perm -002 -type d
```

## PHP Permission Checks

```php
<?
// Check if file is readable
if (!is_readable($file)) {
    die("Cannot read file: $file");
}

// Check if file is writable
if (!is_writable($file)) {
    die("Cannot write to file: $file");
}

// Check if file is executable
if (!is_executable($script)) {
    chmod($script, 0755);
}
?>
```

## umask Considerations

The default umask affects newly created files:

```bash
# Check current umask
umask

# Set umask for script
umask 022  # New files: 644, dirs: 755
umask 077  # New files: 600, dirs: 700
```

## Best Practices

1. **Least privilege** - Only grant necessary permissions
2. **Protect credentials** - Use 600 for files with secrets
3. **Verify after install** - Check permissions are correct
4. **Avoid 777** - Never use world-writable
5. **Document requirements** - Note any special permission needs

## Related Topics

- [PLG File Reference]({% link docs/plg-file.md %})
- [File System Layout]({% link docs/filesystem.md %})
- [Input Validation]({% link docs/security/input-validation.md %})
