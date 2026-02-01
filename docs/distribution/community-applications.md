---
layout: default
title: Community Applications
parent: Distribution
nav_order: 1
---

# Community Applications (CA)

<p style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem;">
  <img src="../../assets/images/logos/Unraid%20Logos/un-mark-gradient.svg" alt="" style="height: 24px;">
  <span>Get your plugin into the official Unraid app store</span>
</p>

## Overview

Community Applications (CA) is the primary plugin/container discovery platform for Unraid. Getting your plugin listed in CA makes it easily discoverable and installable by Unraid users.

{: .placeholder-image }
> 📷 **Screenshot needed:** *CA plugin browser interface*
>
> ![CA browser](../../assets/images/screenshots/ca-browser.png)

## How CA Works

1. CA maintains a repository of application templates
2. Users browse/search within the CA interface
3. Selecting your plugin triggers installation via Plugin Manager
4. CA handles version checking and updates

## Requirements for Listing

To get your plugin listed in Community Applications, you need:

1. **A working PLG file** - Hosted at a stable URL
2. **Support thread** - On the Unraid forums
3. **CA XML template** - Describes your plugin to CA
4. **Icon** - PNG image for the CA interface

## CA XML Template

Create a template XML file for your plugin:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Containers>
    <Plugin>
        <Name>My Plugin Name</Name>
        <PluginURL>https://raw.githubusercontent.com/username/repo/main/myplugin.plg</PluginURL>
        <PluginAuthor>Your Name</PluginAuthor>
        <Description>
A brief description of what your plugin does. This appears in search results.

A longer description can follow. Use plain text, basic formatting is supported.
        </Description>
        <Icon>https://raw.githubusercontent.com/username/repo/main/icon.png</Icon>
        <Category>Tools: Productivity:</Category>
        <Support>https://forums.unraid.net/topic/12345-my-plugin-support/</Support>
        <Project>https://github.com/username/repo</Project>
        <MinVer>6.9.0</MinVer>
        <MaxVer>7.99</MaxVer>
    </Plugin>
</Containers>
```

### Template Elements

| Element | Required | Description |
|---------|----------|-------------|
| `Name` | Yes | Display name in CA interface |
| `PluginURL` | Yes | Direct URL to your .plg file |
| `PluginAuthor` | Yes | Your name/handle |
| `Description` | Yes | What the plugin does |
| `Icon` | Yes | URL to 256x256 PNG icon |
| `Category` | Yes | CA categories (colon-separated) |
| `Support` | Recommended | URL to support forum thread |
| `Project` | Recommended | URL to source code/project |
| `MinVer` | Recommended | Minimum Unraid version |
| `MaxVer` | Optional | Maximum Unraid version |

## Categories

Use appropriate categories to help users find your plugin:

| Category | Description |
|----------|-------------|
| `Tools:` | General utilities and tools |
| `Tools:System` | System management tools |
| `Tools:Utilities` | General utilities |
| `Network:` | Network-related plugins |
| `Network:Management` | Network management |
| `Backup:` | Backup solutions |
| `Productivity:` | Productivity tools |
| `Status:` | Monitoring and status |
| `Security:` | Security-related plugins |

Multiple categories can be combined: `Tools:System:Status:`

## Icon Requirements

- **Format**: PNG (with transparency recommended)
- **Size**: 256x256 pixels (minimum)
- **Style**: Clear, recognizable at small sizes
- **Hosting**: <img src="../../assets/images/logos/GitHub%20Logos/GitHub_Invertocat_White.svg" alt="GitHub" height="16" style="vertical-align: middle;"> GitHub raw URL or other reliable CDN

{: .placeholder-image }
> 📷 **Screenshot needed:** *Plugin icons as displayed in CA*
>
> ![CA icons](../../assets/images/screenshots/ca-plugin-icons.png)

```
https://raw.githubusercontent.com/username/repo/main/images/icon.png
```

## Submission Process

### 1. Prepare Your Plugin

Ensure your plugin:
- Works correctly on supported Unraid versions
- Has a stable PLG file URL
- Includes proper versioning

### 2. Create Support Thread

Create a support thread on the [Unraid Forums](https://forums.unraid.net/forum/90-plugin-support/):
- Choose an appropriate subforum
- Include installation instructions
- Document features and usage
- Monitor for user feedback

### 3. Create CA Template

Host your template XML file in your repository or submit it to the CA templates repository.

### 4. Submit to CA

**Option A: CA Templates Repository (Recommended)**

<img src="../../assets/images/logos/GitHub%20Logos/GitHub_Invertocat_White.svg" alt="GitHub" height="32" style="vertical-align: middle; margin-right: 0.5rem;"> Fork and submit a pull request:

1. Fork the [CA templates repository](https://github.com/Squidly271/plugin-repository)
2. Add your template XML to the appropriate folder
3. Submit a pull request
4. Wait for review and approval

**Option B: Self-Hosted Template**

Contact the CA maintainer via the forums with:
- Your template XML
- Link to your plugin
- Link to your support thread

### 5. Await Approval

The CA maintainer will review your submission:
- Verify plugin works correctly
- Check template accuracy
- Ensure support thread exists
- May request changes

## Updating Your Plugin

When you release updates:

1. **Update your PLG file** - Increment version number
2. **Update changelog** - Add changes in the `<CHANGES>` section
3. **CA auto-detects updates** - No template changes needed for version bumps

If you change URLs or metadata, update your CA template as well.

## Best Practices

### Description Writing

```xml
<Description>
Brief one-line summary of what the plugin does.

Extended description explaining features:
- Feature 1: What it does
- Feature 2: Another capability
- Feature 3: Key functionality

Requirements: List any dependencies or requirements.
</Description>
```

### Version Compatibility

Always specify minimum version requirements:

```xml
<MinVer>6.9.0</MinVer>
```

Set `MaxVer` only if your plugin is known to be incompatible with newer versions:

```xml
<MaxVer>6.12.99</MaxVer>
```

### Changelog Visibility

Keep your PLG changelog updated - CA displays this to users:

```xml
<CHANGES>
### 2026.02.01
- Added new feature X
- Fixed bug in settings page

### 2026.01.15
- Initial release
</CHANGES>
```

## Testing CA Integration

Before submitting, test that your plugin installs correctly:

1. Use the Plugin Manager's "Install Plugin" feature
2. Enter your direct PLG URL
3. Verify installation completes without errors
4. Test all features work as expected
5. Verify uninstallation is clean

## Troubleshooting

### Plugin Not Appearing in CA

- Verify template XML is valid
- Check PluginURL is accessible
- Ensure icon URL works
- Contact CA maintainer if approved but not showing

### Installation Failures

- Check PLG file syntax
- Verify all download URLs work
- Test hash/checksum values
- Review server logs for errors

### Updates Not Detected

- Ensure version number increased in PLG
- Check pluginURL matches CA template
- Clear browser cache and retry

## Resources

- [Community Applications Plugin](https://forums.unraid.net/topic/38582-plug-in-community-applications/)
- [CA Templates Repository](https://github.com/Squidly271/plugin-repository)
- [Unraid Plugin Support Forums](https://forums.unraid.net/forum/90-plugin-support/)

## Example Complete Workflow

1. **Develop**: Create and test your plugin locally
2. **Host**: Push to GitHub with PLG, icon, and template
3. **Forum**: Create support thread with documentation
4. **Submit**: Fork CA repo, add template, create PR
5. **Maintain**: Monitor thread, respond to issues, push updates

## Related Topics

- [PLG File Reference](../plg-file.md)
- [Build and Packaging](../build-and-packaging.md)
- [Plugin Lifecycle](../advanced/update-mechanisms.md)
