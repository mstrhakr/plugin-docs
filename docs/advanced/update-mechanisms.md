---
layout: default
title: Update Mechanisms
parent: Advanced Topics
nav_order: 6
---

# Update Mechanisms

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Plugins should support easy updates. Unraid's plugin system checks for updates automatically when configured correctly. This guide covers version checking, update notifications, and auto-update patterns.

## PLG Version Tag

Your PLG file's version is defined in the DOCTYPE:

```xml
<!DOCTYPE PLUGIN [
  <!ENTITY name      "yourplugin">
  <!ENTITY author    "Your Name">
  <!ENTITY version   "2024.01.15">
  <!ENTITY pluginURL "https://raw.githubusercontent.com/you/repo/main/yourplugin.plg">
]>

<PLUGIN name="&name;" author="&author;" version="&version;" pluginURL="&pluginURL;">
```

## Version Numbering

Common versioning schemes:

| Scheme | Example | Notes |
|--------|---------|-------|
| Date-based | `2024.01.15` | Common for Unraid plugins |
| SemVer | `1.2.3` | Major.Minor.Patch |
| Hybrid | `2024.01.15a` | Date with suffix |

## Update Checking

Unraid checks the `pluginURL` for updates. The remote PLG version is compared to installed version.

### Hosting PLG Files

**GitHub Raw (most common):**
```xml
<!ENTITY pluginURL "https://raw.githubusercontent.com/username/repo/main/yourplugin.plg">
```

**GitHub Pages:**
```xml
<!ENTITY pluginURL "https://username.github.io/repo/yourplugin.plg">
```

## GitHub Releases Pattern

Use GitHub Releases for versioned downloads:

```xml
<!DOCTYPE PLUGIN [
  <!ENTITY name      "yourplugin">
  <!ENTITY version   "1.2.3">
  <!ENTITY repo      "username/yourplugin">
  <!ENTITY pluginURL "https://raw.githubusercontent.com/&repo;/main/yourplugin.plg">
]>

<!-- Download from releases -->
<FILE Name="/boot/config/plugins/&name;/yourpackage.txz" Run="upgradepkg --install-new">
<URL>https://github.com/&repo;/releases/download/v&version;/yourpackage.txz</URL>
</FILE>
```

## Changelog

Provide a changelog for users:

```xml
<CHANGES>
###2024.01.15
- Added new feature X
- Fixed bug Y
- Improved performance

###2024.01.01
- Initial release
</CHANGES>
```

## Manual Update Check

Implement in-plugin update checking:

```php
<?
function checkForUpdate($currentVersion) {
    $pluginURL = 'https://raw.githubusercontent.com/user/repo/main/yourplugin.plg';
    
    // Fetch remote PLG
    $remote = @file_get_contents($pluginURL);
    if (!$remote) return false;
    
    // Extract version
    if (preg_match('/version\s*=\s*"([^"]+)"/', $remote, $matches)) {
        $remoteVersion = $matches[1];
        return version_compare($remoteVersion, $currentVersion, '>') 
            ? $remoteVersion 
            : false;
    }
    
    return false;
}

$installedVersion = '2024.01.01';
$newVersion = checkForUpdate($installedVersion);

if ($newVersion) {
    echo "<p class='notice'>Update available: $newVersion</p>";
}
?>
```

## Branch Strategies

### Stable Releases

```
main/master branch → pluginURL for stable releases
```

### Development Branch

Offer a development version:

```xml
<!-- Stable -->
<!ENTITY pluginURL "https://raw.githubusercontent.com/user/repo/main/yourplugin.plg">

<!-- Or development -->
<!ENTITY pluginURL "https://raw.githubusercontent.com/user/repo/develop/yourplugin.plg">
```

## Update Notifications

Notify users of updates:

```php
<?
if ($updateAvailable) {
    exec("/usr/local/emhttp/webGui/scripts/notify " .
         "-e 'Your Plugin' " .
         "-s 'Update Available' " .
         "-d 'Version $newVersion is available' " .
         "-i 'normal'");
}
?>
```

## Auto-Update Considerations

TODO: Document auto-update patterns if supported

## Versioned File Downloads

Ensure old versions remain available:

```xml
<!-- Good: Versioned URL -->
<URL>https://github.com/user/repo/releases/download/v1.2.3/package.txz</URL>

<!-- Risky: Latest always -->
<URL>https://github.com/user/repo/releases/latest/download/package.txz</URL>
```

## Checksums

Always include checksums for security:

```xml
<FILE Name="/boot/config/plugins/&name;/package.txz">
<URL>https://example.com/package.txz</URL>
<MD5>abc123def456789...</MD5>
</FILE>
```

Generate MD5:
```bash
md5sum package.txz
```

## CI/CD Integration

Automate releases with GitHub Actions:

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags:
      - 'v*'
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Update version in PLG
        run: |
          VERSION=${GITHUB_REF#refs/tags/v}
          sed -i "s/version   \".*\"/version   \"$VERSION\"/" yourplugin.plg
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            yourplugin.plg
            packages/*.txz
```

## Related Topics

- [PLG File Reference]({% link docs/plg-file.md %})
- [Build and Packaging]({% link docs/build-and-packaging.md %})
- [Package Management]({% link docs/advanced/package-management.md %})
