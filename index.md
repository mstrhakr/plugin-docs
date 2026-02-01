---
layout: default
title: Home
nav_order: 1
permalink: /
---

<div style="text-align: center; margin-bottom: 2rem;">
  <a href="https://unraid.net/">
    <img src="assets/images/logos/Unraid%20Logos/UN-logotype-gradient.svg" alt="Unraid" style="height: 60px;">
  </a>
</div>

# Unraid Plugin Development Documentation

Welcome to the community-maintained documentation for building plugins for [Unraid OS](https://unraid.net/).

![Unraid Plugins page showing installed plugins](assets/images/screenshots/plugins-installed.png)

{: .warning }
> This is unofficial documentation maintained by the community. While we strive for accuracy, please verify critical information against official sources and existing plugins.

## Quick Start

New to plugin development? Start here:

1. [Introduction to Plugins]({% link docs/introduction.md %}) - What are plugins and how do they work?
2. [Your First Plugin]({% link docs/getting-started.md %}) - Step-by-step tutorial
3. [PLG File Reference]({% link docs/plg-file.md %}) - The plugin installer format
4. [Page Files]({% link docs/page-files.md %}) - Creating web UI pages

## Documentation Sections

### Getting Started
- [Introduction]({% link docs/introduction.md %}) - Plugin system overview
- [File System Layout]({% link docs/filesystem.md %}) - Where files go and why
- [PLG File Reference]({% link docs/plg-file.md %}) - Plugin installer XML format
- [Page Files]({% link docs/page-files.md %}) - Web UI development
- [Event System]({% link docs/events.md %}) - Responding to system events

### Core Concepts
- [Dynamix Framework]({% link docs/core/dynamix-framework.md %}) - The `$Dynamix` global array
- [Plugin Settings Storage]({% link docs/core/plugin-settings-storage.md %}) - `.cfg` files and `parse_plugin_cfg()`
- [CSRF Tokens]({% link docs/core/csrf-tokens.md %}) - Form security requirements
- [nchan/WebSocket]({% link docs/core/nchan-websocket.md %}) - Real-time updates
- [Notifications System]({% link docs/core/notifications-system.md %}) - User alerts
- [Cron Jobs]({% link docs/core/cron-jobs.md %}) - Scheduled tasks
- [rc.d Scripts]({% link docs/core/rc-d-scripts.md %}) - Service management
- [Multi-language Support]({% link docs/core/multi-language-support.md %}) - Translations

### UI Development
- [Form Controls]({% link docs/ui/form-controls.md %}) - Standard form elements
- [JavaScript Patterns]({% link docs/ui/javascript-patterns.md %}) - jQuery and AJAX
- [Icons and Styling]({% link docs/ui/icons-and-styling.md %}) - Font Awesome and CSS
- [Tab Pages]({% link docs/ui/tab-pages.md %}) - Multi-tab interfaces
- [Dashboard Tiles]({% link docs/ui/dashboard-tiles.md %}) - Custom dashboard tiles

### Advanced Topics
- [Docker Integration]({% link docs/advanced/docker-integration.md %}) - Container management
- [Array/Disk Access]({% link docs/advanced/array-disk-access.md %}) - Disk and share info
- [User Scripts Integration]({% link docs/advanced/user-scripts-integration.md %}) - Working with User Scripts
- [Debugging Techniques]({% link docs/advanced/debugging-techniques.md %}) - Logging and troubleshooting
- [Package Management]({% link docs/advanced/package-management.md %}) - Building `.txz` packages
- [Update Mechanisms]({% link docs/advanced/update-mechanisms.md %}) - Version checking and updates

### Security & Best Practices
- [Input Validation]({% link docs/security/input-validation.md %}) - Sanitizing user input
- [File Permissions]({% link docs/security/file-permissions.md %}) - Correct permissions
- [Error Handling]({% link docs/security/error-handling.md %}) - Graceful failures

### Reference
- [Plugin Command]({% link docs/plugin-command.md %}) - CLI tool usage
- [Build and Packaging]({% link docs/build-and-packaging.md %}) - CI/CD pipelines
- [Example Plugins]({% link docs/examples.md %}) - Learn from real plugins
- [PHP Functions Reference]({% link docs/reference/php-functions-reference.md %}) - Available helpers
- [File Path Reference]({% link docs/reference/file-path-reference.md %}) - Important directories
- [Event Types Reference]({% link docs/reference/event-types-reference.md %}) - All event hooks

## Why This Documentation?

As noted in [this forum thread](https://forums.unraid.net/topic/52623-plugin-system-documentation/), official documentation for Unraid plugin development is scattered and incomplete. Most developers learn by:

- Reverse engineering existing plugins
- Asking questions in forums
- Trial and error

This project aims to consolidate that knowledge into a single, well-organized resource.

## Contributing

This documentation is open source! Found an error? Want to add content?

- <img src="assets/images/logos/GitHub%20Logos/GitHub_Invertocat_White.svg" alt="" class="github-icon-inline"> [View on GitHub](https://github.com/mstrhakr/unraid-plugin-docs)
- <img src="assets/images/logos/GitHub%20Logos/GitHub_Invertocat_White.svg" alt="" class="github-icon-inline"> [Report an Issue](https://github.com/mstrhakr/unraid-plugin-docs/issues)
- [Contributing Guide](CONTRIBUTING.md)

## Resources

- [Unraid Forums](https://forums.unraid.net/)
- [Official Unraid Docs](https://docs.unraid.net/)
- [Community Applications](https://github.com/Squidly271/community.applications)
