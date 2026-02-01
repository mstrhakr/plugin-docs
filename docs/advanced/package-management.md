---
layout: default
title: Package Management
parent: Advanced Topics
nav_order: 5
---

# Package Management

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Plugins often need to install additional software packages. Unraid uses Slackware packages (`.txz` format). This guide covers building, hosting, and installing packages.

## Package Format

Slackware packages are `.txz` (or `.tgz`) archives with a specific structure:

```
package-name-version-arch-build.txz
├── install/
│   ├── slack-desc          # Package description
│   └── doinst.sh          # Post-install script (optional)
├── usr/
│   └── local/
│       └── bin/
│           └── myprogram   # Your files
└── etc/
    └── myprogram.conf      # Config files
```

## Building a Package

### Directory Structure

```bash
# Create package directory
mkdir -p /tmp/mypackage-1.0-x86_64-1/install
mkdir -p /tmp/mypackage-1.0-x86_64-1/usr/local/bin

# Add your files
cp myprogram /tmp/mypackage-1.0-x86_64-1/usr/local/bin/
chmod 755 /tmp/mypackage-1.0-x86_64-1/usr/local/bin/myprogram
```

### Package Description (slack-desc)

```
# /tmp/mypackage-1.0-x86_64-1/install/slack-desc
       |-----handy-ruler------------------------------------------------------|
mypackage: mypackage (Short description)
mypackage:
mypackage: Longer description of what this package does.
mypackage: Can span multiple lines.
mypackage:
mypackage:
mypackage:
mypackage:
mypackage:
mypackage:
mypackage:
```

### Post-Install Script (optional)

```bash
#!/bin/bash
# /tmp/mypackage-1.0-x86_64-1/install/doinst.sh

# Create symlinks, set permissions, etc.
chmod 755 /usr/local/bin/myprogram

# Create config if not exists
if [ ! -f /etc/myprogram.conf ]; then
    cp /etc/myprogram.conf.new /etc/myprogram.conf
fi
```

### Create Package

```bash
cd /tmp/mypackage-1.0-x86_64-1
makepkg -l y -c n ../mypackage-1.0-x86_64-1.txz
```

## Installing Packages

### Via PLG FILE

```xml
<FILE Name="/boot/config/plugins/yourplugin/mypackage-1.0-x86_64-1.txz" Run="upgradepkg --install-new">
<URL>https://github.com/you/repo/releases/download/v1.0/mypackage-1.0-x86_64-1.txz</URL>
<MD5>abc123def456...</MD5>
</FILE>
```

### Manual Installation

```bash
# Install
installpkg /path/to/package.txz

# Upgrade
upgradepkg /path/to/package.txz

# Remove
removepkg package-name
```

## Slackware Package Sources

Many packages are available from:

- [SlackBuilds.org](https://slackbuilds.org/) - Build scripts
- [Slackware mirrors](http://www.slackware.com/getslack/) - Official packages
- [Alien BOB](http://www.slackware.com/~alien/) - Additional packages

## Using Pre-built Packages

### From Slackware Repositories

```xml
<FILE Name="/boot/config/plugins/yourplugin/package.txz" Run="upgradepkg --install-new">
<URL>http://slackware.cs.utah.edu/pub/slackware/slackware64-15.0/slackware64/ap/package-version.txz</URL>
<MD5>checksum_here</MD5>
</FILE>
```

### Hosting Your Own

GitHub Releases is a common choice:

```xml
<URL>https://github.com/yourusername/yourrepo/releases/download/v1.0/package.txz</URL>
```

## Dependencies

Handle dependencies by installing them first in your PLG:

```xml
<!-- Install dependency first -->
<FILE Name="/boot/config/plugins/yourplugin/dependency.txz" Run="upgradepkg --install-new">
<URL>https://example.com/dependency.txz</URL>
</FILE>

<!-- Then your package -->
<FILE Name="/boot/config/plugins/yourplugin/yourpackage.txz" Run="upgradepkg --install-new">
<URL>https://example.com/yourpackage.txz</URL>
</FILE>
```

## Package Naming Convention

```
name-version-arch-build.txz

name:    Package name (lowercase, no spaces)
version: Version number (e.g., 1.0, 2.1.3)
arch:    Architecture (x86_64, noarch, arm)
build:   Build number (1, 2, etc.)

Examples:
mypackage-1.0-x86_64-1.txz
python-library-2.5.0-noarch-1.txz
```

## Cleanup on Uninstall

In your PLG REMOVE section:

```xml
<FILE Run="/bin/bash" Method="remove">
<INLINE>
removepkg mypackage-1.0-x86_64-1
rm -f /boot/config/plugins/yourplugin/mypackage-*.txz
</INLINE>
</FILE>
```

## Related Topics

- [PLG File Reference]({% link docs/plg-file.md %})
- [Build and Packaging]({% link docs/build-and-packaging.md %})
- [Update Mechanisms]({% link docs/advanced/update-mechanisms.md %})

## References

- [Slackware Package Documentation](http://www.slackware.com/config/packages.php)
- [SlackBuilds.org HOWTO](https://slackbuilds.org/howto/)
