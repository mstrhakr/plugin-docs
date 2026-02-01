---
layout: default
title: Plugin Command Reference
nav_order: 7
---

# Plugin Command Reference

The `plugin` command is the CLI tool for managing Unraid plugins. It handles installation, updates, removal, and status checks.

{: .placeholder-image }
> 📷 **Screenshot needed:** *Terminal showing the plugin command help output or a plugin installation in progress*
>
> ![Plugin command help](../assets/images/screenshots/plugin-command-help.png)

## Basic Usage

```bash
plugin <command> <plugin-file>
```

## Commands

### install

Install a plugin from a local file or URL:

```bash
# From URL
plugin install https://raw.githubusercontent.com/user/repo/main/myplugin.plg

# From local file
plugin install /path/to/myplugin.plg

# Force install (even if lower version)
plugin install /path/to/myplugin.plg forced
```

**What happens:**
1. Downloads the PLG file (if URL)
2. Processes all `<FILE>` elements with `install` method
3. Copies PLG to `/boot/config/plugins/`
4. Creates symlink in `/var/log/plugins/`

{: .placeholder-image }
> 📷 **Screenshot needed:** *Terminal output showing a successful plugin installation with download progress and confirmation message*
>
> ![Plugin install output](../assets/images/screenshots/plugin-install-output.png)

### remove

Remove an installed plugin:

```bash
plugin remove myplugin.plg
```

**What happens:**
1. Processes all `<FILE>` elements with `remove` method
2. Deletes symlink from `/var/log/plugins/`
3. Moves PLG to `/boot/config/plugins-removed/`

### check

Check if a newer version is available:

```bash
plugin check myplugin.plg
```

**What happens:**
1. Downloads PLG from `pluginURL` to `/tmp/plugins/`
2. Extracts and outputs the version string
3. Exits 0 if newer version available

### checkall

Check all installed plugins for updates:

```bash
plugin checkall
```

Runs `plugin check` for each plugin in `/var/log/plugins/`.

### update

Update a plugin to the latest version:

```bash
plugin update myplugin.plg
```

**What happens:**
1. Looks for new PLG in `/tmp/plugins/`
2. Runs install method of new version
3. Replaces old PLG in `/boot/config/plugins/`
4. Updates symlink in `/var/log/plugins/`

> 💡 Run `plugin check` first to download the latest version

### Attribute Queries

Get any attribute from a PLG file:

```bash
# Get version
plugin version /var/log/plugins/myplugin.plg

# Get author
plugin author /var/log/plugins/myplugin.plg

# Get any attribute
plugin pluginURL /var/log/plugins/myplugin.plg
```

## Directory Reference

| Directory | Purpose |
|-----------|---------|
| `/boot/config/plugins/` | Active plugin PLG files |
| `/boot/config/plugins-error/` | Failed installations |
| `/boot/config/plugins-removed/` | Uninstalled plugins |
| `/boot/config/plugins-stale/` | Superseded versions |
| `/tmp/plugins/` | Downloaded updates |
| `/var/log/plugins/` | Symlinks to installed plugins |

## Practical Examples

### Full Update Workflow

```bash
# Check for updates
plugin check myplugin.plg

# If update available, install it
plugin update myplugin.plg
```

### List Installed Plugins

```bash
ls -la /var/log/plugins/
```

### Check Plugin Version

```bash
plugin version /var/log/plugins/myplugin.plg
```

### Reinstall a Plugin

```bash
# Remove first
plugin remove myplugin.plg

# Then install fresh
plugin install /boot/config/plugins-removed/myplugin.plg
```

### Debug Installation

Watch the output carefully when installing:

```bash
plugin install myplugin.plg 2>&1 | tee /tmp/install.log
```

## Error Handling

### Plugin Moved to plugins-error

Installation failed. Check:
1. MD5 checksum mismatches
2. Download failures
3. Script errors
4. Missing dependencies

### Plugin Moved to plugins-stale

A newer version is already installed. Use `forced` flag if needed:

```bash
plugin install myplugin.plg forced
```

### Update Not Working

Ensure `pluginURL` attribute is set in your PLG:

```xml
<PLUGIN ... pluginURL="https://raw.githubusercontent.com/user/repo/main/myplugin.plg">
```

## Scripting with Plugin Command

### Check All Updates in Script

```bash
#!/bin/bash
for plg in /var/log/plugins/*.plg; do
    name=$(basename "$plg")
    echo "Checking $name..."
    if plugin check "$name" >/dev/null 2>&1; then
        echo "  Update available!"
    fi
done
```

### Get Plugin Info

```bash
#!/bin/bash
PLG="/var/log/plugins/myplugin.plg"
echo "Plugin: $(plugin name $PLG)"
echo "Version: $(plugin version $PLG)"
echo "Author: $(plugin author $PLG)"
```

## Notes

- The `plugin` command is specific to Unraid
- Plugins use Slackware's package format (`.txz`)
- The `upgradepkg` and `removepkg` commands handle package operations
- Always test plugins on a non-production server first

## See Also

- [PLG File Reference](plg-file.md)
- [Packaging](packaging.md)
- [Troubleshooting](troubleshooting.md)
