# Plugin Development Documentation for Unraid®

> **The community-maintained guide to building plugins for Unraid® OS**
>
> *Unraid® is a registered trademark of Lime Technology, Inc. This project is not affiliated with, endorsed by, or sponsored by Lime Technology, Inc.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with Unraid®](https://img.shields.io/badge/Works_with-Unraid®_6.9+-orange.svg)](https://unraid.net/)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Visitors](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fplugin-docs.mstrhakr.com&count_bg=%23FF8C00&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Page+Views&edge_flat=false)](https://stats.plugin-docs.mstrhakr.com)

<p>
  <a href="https://github.com/mstrhakr/plugin-docs"><img src="assets/images/logos/GitHub%20Logos/GitHub_Lockup_White.svg" alt="View on GitHub" height="32"></a>
  &nbsp;&nbsp;
  <a href="https://github.com/features/copilot"><img src="assets/images/logos/GitHub%20Logos/GitHub_Copilot_Lockup_White.svg" alt="Built with GitHub Copilot" height="28"></a>
  &nbsp;&nbsp;
  <a href="https://stats.plugin-docs.mstrhakr.com"><img src="https://img.shields.io/badge/📊_View_Analytics-GoatCounter-9cf" alt="View Analytics" height="20"></a>
</p>

---

## 🌐 [**Read the Documentation →**](https://mstrhakr.github.io/unraid-plugin-docs/)

> **📚 The full documentation is available at: [mstrhakr.github.io/unraid-plugin-docs](https://mstrhakr.github.io/unraid-plugin-docs/)**

---

## 📖 About This Documentation

This is the **unofficial, community-driven** documentation for developing plugins for [Unraid® OS](https://unraid.net/). The Unraid® plugin system is powerful but has historically lacked comprehensive documentation. This project aims to fill that gap by providing clear, well-organized, and up-to-date resources for plugin developers.

> ⚠️ **Disclaimer**: This is not official Lime Technology documentation. Unraid® is a registered trademark of Lime Technology, Inc. This project is not affiliated with, endorsed by, or sponsored by Lime Technology, Inc. While every effort is made to ensure accuracy, please verify critical information against official sources and existing plugins.

---

## 🚀 Quick Start

New to Unraid® plugin development? Start here:

1. **[Introduction to Plugins](docs/introduction.md)** - What are plugins and how do they work?
2. **[Plugin File Structure](docs/plg-file.md)** - Anatomy of a `.plg` file
3. **[Your First Plugin](docs/getting-started.md)** - Step-by-step tutorial
4. **[Web UI Pages](docs/page-files.md)** - Creating `.page` files for the web GUI

---

## 📚 Documentation Index

### Core Concepts

| Topic | Description |
|-------|-------------|
| [Introduction](docs/introduction.md) | Overview of the Unraid® plugin system |
| [PLG File Reference](docs/plg-file.md) | Complete reference for `.plg` XML structure |
| [Page Files](docs/page-files.md) | Creating web UI pages (`.page` files) |
| [Plugin Lifecycle](docs/lifecycle.md) | Installation, updates, and removal |
| [File System Layout](docs/filesystem.md) | Where files go and why |

### Web UI Development

| Topic | Description |
|-------|-------------|
| [Page Headers](docs/page-headers.md) | Menu, Title, Type, Icon, and more |
| [Dynamix Markdown](docs/dynamix-markdown.md) | The form syntax used in Unraid® UI |
| [PHP Integration](docs/php-integration.md) | Using PHP in your pages |
| [JavaScript & AJAX](docs/javascript.md) | Client-side scripting |
| [CSS & Theming](docs/theming.md) | Styling your plugin UI |

### Events & System Integration

| Topic | Description |
|-------|-------------|
| [Event System](docs/events.md) | Responding to array start/stop, Docker, etc. |
| [Configuration Files](docs/config-files.md) | Storing and reading plugin settings |
| [Shell Scripts](docs/shell-scripts.md) | Background tasks and automation |
| [Docker Integration](docs/docker-integration.md) | Working with Docker containers |

### Packaging & Distribution

| Topic | Description |
|-------|-------------|
| [Package Building](docs/packaging.md) | Creating `.txz` packages |
| [Versioning](docs/versioning.md) | Version strategies and update checking |
| [Community Applications](docs/community-apps.md) | Publishing to the CA App Store |
| [Best Practices](docs/best-practices.md) | Tips from experienced developers |

### Reference

| Topic | Description |
|-------|-------------|
| [Plugin Command](docs/plugin-command.md) | Using the `plugin` CLI tool |
| [API Reference](docs/api-reference.md) | Available PHP functions and variables |
| [Example Plugins](docs/examples.md) | Links to well-documented plugins |
| [Troubleshooting](docs/troubleshooting.md) | Common issues and solutions |

---

## 🗂️ Plugin System Overview

At a high level, an Unraid® plugin consists of:

```
┌─────────────────────────────────────────────────────────────────┐
│                        myplugin.plg                             │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  XML-based installer that:                               │   │
│  │  • Downloads and extracts packages                       │   │
│  │  • Runs install/remove scripts                           │   │
│  │  • Defines plugin metadata (name, version, author)       │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    myplugin-package.txz                         │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Slackware package containing:                           │   │
│  │  /usr/local/emhttp/plugins/myplugin/                     │   │
│  │    ├── myplugin.page       (Web UI)                      │   │
│  │    ├── myplugin.settings.page                            │   │
│  │    ├── default.cfg                                       │   │
│  │    ├── php/                                              │   │
│  │    ├── scripts/                                          │   │
│  │    ├── javascript/                                       │   │
│  │    └── event/                                            │   │
│  │        ├── started                                       │   │
│  │        └── stopping_docker                               │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔗 Key Directories

| Path | Purpose | Persistence |
|------|---------|-------------|
| `/boot/config/plugins/` | Plugin files stored on USB flash | ✅ Survives reboot |
| `/boot/config/plugins/myplugin/` | Plugin config and cached files | ✅ Survives reboot |
| `/usr/local/emhttp/plugins/myplugin/` | Active plugin files (web UI) | ❌ RAM disk |
| `/var/log/plugins/` | Symlinks indicating installed plugins | ❌ RAM disk |
| `/tmp/plugins/` | Downloaded plugin files for updates | ❌ Temporary |

---

## 🎯 emhttp Events

Plugins can respond to system events by placing executable scripts in their `event/` directory:

| Event | Triggered When |
|-------|----------------|
| `driver_loaded` | Early in emhttp initialization |
| `starting` | Array start begins |
| `array_started` | Array devices are valid |
| `disks_mounted` | Disks and shares are mounted |
| `docker_started` | Docker service starts |
| `libvirt_started` | VM service starts |
| `started` | Array start completes |
| `stopping` | Array stop begins |
| `stopping_docker` | About to stop Docker |
| `stopping_libvirt` | About to stop VMs |
| `unmounting_disks` | About to unmount disks |
| `stopped` | Array has stopped |
| `poll_attributes` | SMART data polled |

See [Event System](docs/events.md) for full details.

---

## 🛠️ Development Tips

### Quick Testing Workflow

1. Edit files directly in `/usr/local/emhttp/plugins/myplugin/` on your server
2. Refresh the browser to see changes (PHP/HTML changes are instant)
3. A reboot will restore original files from the package, so copy changes back to your source!

### Useful CLI Commands

```bash
# Install a plugin
plugin install /path/to/myplugin.plg

# Check for plugin updates
plugin check myplugin.plg

# Update a plugin
plugin update myplugin.plg

# Remove a plugin
plugin remove myplugin.plg

# Get plugin version
plugin version /var/log/plugins/myplugin.plg
```

---

## 🤝 Contributing

<a href="https://github.com/mstrhakr/plugin-docs"><img src="assets/images/logos/GitHub%20Logos/GitHub_Invertocat_White.svg" alt="GitHub" height="48" align="right"></a>

This documentation is a community effort! Contributions are welcome:

- **Found an error?** [Open an issue](../../issues)
- **Want to add content?** [Submit a pull request](../../pulls)
- **Have questions?** [Start a discussion](../../discussions)

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 Resources & Links

### Official Resources
- [Unraid® Forums](https://forums.unraid.net/) - The primary community hub
- [Unraid® Documentation](https://docs.unraid.net/) - Official docs
- [Plugin Support Forum](https://forums.unraid.net/forum/77-plugin-support/)
- [Programming Forum](https://forums.unraid.net/forum/57-programming/)

### Community Developer Resources
- [Community Applications Plugin](https://github.com/Squidly271/community.applications) - The app store for plugins
- [Dynamix Plugins](https://github.com/bergware/dynamix) - Reference implementations by @bonienl
- [Plugin Template Discussions](https://forums.unraid.net/topic/52623-plugin-system-documentation/)

### Historical References
- [How does the plugin system work?](https://forums.unraid.net/topic/33322-how-does-the-plugin-system-work-documentation-added-wip/) - Original documentation (partially outdated)

---

## 📄 License

This documentation is licensed under [CC BY-SA 4.0](LICENSE). Code examples are provided under the [MIT License](LICENSE-CODE).

---

<p align="center">
  <strong>Made with ❤️ by the Unraid® community</strong><br>
  <a href="https://unraid.net/">unraid.net</a>
</p>
