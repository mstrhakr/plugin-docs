---
layout: default
title: Hosting Your Plugin
parent: Distribution
nav_order: 2
---

# Hosting Your Plugin

Where and how to host your plugin files for distribution.

## Recommended: GitHub

GitHub is the most popular choice for hosting Unraid® plugins:

### Advantages

- **Free hosting** for public repositories
- **Releases** feature for versioned downloads
- **Raw file URLs** work directly with the Plugin Manager
- **Version control** for your source code
- **Issue tracking** for bug reports

### Setting Up GitHub Hosting

1. Create a public repository for your plugin
2. Include your PLG file in the repository root
3. Use GitHub Releases for versioned packages

### URL Structure

For raw file access, use:
```
https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/filename.plg
```

For releases:
```
https://github.com/USERNAME/REPO/releases/download/TAG/filename.txz
```

## Alternative Hosting Options

### GitLab

Similar to GitHub with free public repositories and raw file access.

### Self-Hosted

You can host files on your own web server, but ensure:
- HTTPS is available (recommended)
- Files are publicly accessible
- URLs are stable and won't change

## PLG File URL Requirements

Your PLG file URL must:
- Be publicly accessible (no authentication)
- Return the raw file content (not an HTML page)
- Be stable for update checking

## Package Hosting

For your TXZ packages referenced in the PLG file:

```xml
<FILE Name="/boot/config/plugins/&name;/&name;-&version;.txz" Run="upgradepkg --install-new">
<URL>&gitURL;/releases/download/&version;/&name;-&version;.txz</URL>
</FILE>
```

Using GitHub Releases ensures:
- Version-specific URLs that don't change
- Download statistics
- Easy rollback to previous versions

## Best Practices

1. **Use versioned URLs** - Don't overwrite files at the same URL
2. **Keep old versions available** - Users may need to rollback
3. **Use HTTPS** - Some systems may require secure connections
4. **Test your URLs** - Verify files download correctly before publishing
