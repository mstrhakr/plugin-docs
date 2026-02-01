---
layout: default
title: Home
nav_order: 1
permalink: /
---

# Unraid Plugin Development Documentation

Welcome to the community-maintained documentation for building plugins for [Unraid OS](https://unraid.net/).

{: .warning }
> This is unofficial documentation maintained by the community. While we strive for accuracy, please verify critical information against official sources and existing plugins.

## Quick Start

New to plugin development? Start here:

1. [Introduction to Plugins]({% link docs/introduction.md %}) - What are plugins and how do they work?
2. [Your First Plugin]({% link docs/getting-started.md %}) - Step-by-step tutorial
3. [PLG File Reference]({% link docs/plg-file.md %}) - The plugin installer format
4. [Page Files]({% link docs/page-files.md %}) - Creating web UI pages

## Documentation Sections

### Core Concepts
- [Introduction]({% link docs/introduction.md %}) - Plugin system overview
- [File System Layout]({% link docs/filesystem.md %}) - Where files go and why
- [PLG File Reference]({% link docs/plg-file.md %}) - Plugin installer XML format
- [Page Files]({% link docs/page-files.md %}) - Web UI development
- [Event System]({% link docs/events.md %}) - Responding to system events

### Reference
- [Plugin Command]({% link docs/plugin-command.md %}) - CLI tool usage
- [Build and Packaging]({% link docs/build-and-packaging.md %}) - CI/CD pipelines, versioning, and distribution
- [Example Plugins]({% link docs/examples.md %}) - Learn from real plugins

## Why This Documentation?

As noted in [this forum thread](https://forums.unraid.net/topic/52623-plugin-system-documentation/), official documentation for Unraid plugin development is scattered and incomplete. Most developers learn by:

- Reverse engineering existing plugins
- Asking questions in forums
- Trial and error

This project aims to consolidate that knowledge into a single, well-organized resource.

## Contributing

This documentation is open source! Found an error? Want to add content?

- [View on GitHub](https://github.com/mstrhakr/unraid-plugin-docs)
- [Report an Issue](https://github.com/mstrhakr/unraid-plugin-docs/issues)
- [Contributing Guide](CONTRIBUTING.md)

## Resources

- [Unraid Forums](https://forums.unraid.net/)
- [Official Unraid Docs](https://docs.unraid.net/)
- [Community Applications](https://github.com/Squidly271/community.applications)
