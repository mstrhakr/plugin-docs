---
layout: default
title: Support Resources
parent: Distribution
nav_order: 3
---

# Support Resources

Providing support for your plugin users.

## Unraid Forums

The [Unraid Forums](https://forums.unraid.net/) are the primary place for plugin support.

### Creating a Support Thread

1. Post in the **Plugin Support** section
2. Use a clear title: `[Plugin] Your Plugin Name`
3. Include in your first post:
   - Plugin description and features
   - Installation instructions
   - Requirements and compatibility
   - Known issues
   - Changelog
   - Links to source code

### Forum Best Practices

- **Monitor regularly** - Users expect responses within a few days
- **Be patient** - Not all users are technical
- **Update the first post** - Keep installation instructions current
- **Document common issues** - Create a FAQ section

## GitHub Issues

If your plugin is hosted on GitHub, Issues provide structured bug tracking:

### Advantages

- Searchable history
- Labels and milestones
- Integration with commits and PRs
- Markdown formatting

### Issue Templates

Create `.github/ISSUE_TEMPLATE/` templates for:
- Bug reports
- Feature requests

## Documentation

Good documentation reduces support burden:

### README.md

Include in your repository:
- What the plugin does
- Installation instructions
- Configuration options
- Troubleshooting steps

### In-Plugin Help

Consider adding help text directly in your plugin's settings page using the Dynamix help system.

## Community Applications Integration

When listed in CA, users can:
- See your support thread link
- Report issues through CA's interface
- Access your documentation

Ensure your CA template includes:
```xml
<Support>https://forums.unraid.net/topic/XXXXX-your-plugin/</Support>
```

## Handling Common Issues

### Installation Failures

Guide users to check:
- `/var/log/plugins/plugin-name.plg` for installation logs
- Network connectivity for downloads
- Unraid version compatibility

### Plugin Not Working

Ask users for:
- Unraid version
- Plugin version
- Relevant log entries
- Steps to reproduce

## Version Support Policy

Be clear about which Unraid versions you support:
- Current stable release
- Previous stable release (recommended)
- Beta/RC versions (optional)
