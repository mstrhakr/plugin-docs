# Plugin Development Documentation for Unraid®

> **The community-maintained guide to building plugins for Unraid® OS**
>
> *Unraid® is a registered trademark of Lime Technology, Inc. This project is not affiliated with, endorsed by, or sponsored by Lime Technology, Inc.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with Unraid®](https://img.shields.io/badge/Works_with-Unraid®_6.9+-orange.svg)](https://unraid.net/)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Total Views](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fstats.plugin-docs.mstrhakr.com%2Fcounter%2FTOTAL.json&query=%24.count&label=views&color=blue)](https://stats.plugin-docs.mstrhakr.com)

---

## 🌐 [**Read the Documentation →**](https://plugin-docs.mstrhakr.com/docs/)

---

## 📖 About This Documentation

This is the **unofficial, community-driven** documentation for developing plugins for [Unraid® OS](https://unraid.net/). The Unraid® plugin system is powerful but has historically lacked comprehensive documentation. This project aims to fill that gap by providing clear, well-organized, and up-to-date resources for plugin developers.

> ⚠️ **Disclaimer**: This is not official Lime Technology documentation. Unraid® is a registered trademark of Lime Technology, Inc. This project is not affiliated with, endorsed by, or sponsored by Lime Technology, Inc. While every effort is made to ensure accuracy, please verify critical information against official sources and existing plugins.

---

## 🚀 Quick Start

New to Unraid® plugin development? Start here:

1. **[Introduction to Plugins](https://plugin-docs.mstrhakr.com/docs/introduction.html)** - What are plugins and how do they work?
2. **[Plugin File Structure](https://plugin-docs.mstrhakr.com/docs/plg-file.html)** - Anatomy of a `.plg` file
3. **[Your First Plugin](https://plugin-docs.mstrhakr.com/docs/getting-started.html)** - Step-by-step tutorial
4. **[Web UI Pages](https://plugin-docs.mstrhakr.com/docs/page-files.html)** - Creating `.page` files for the web GUI

---

## 📚 Documentation Index

### Getting Started

| Topic | Description |
|-------|-------------|
| [Introduction](https://plugin-docs.mstrhakr.com/docs/introduction.html) | Overview of the Unraid® plugin system |
| [Your First Plugin](https://plugin-docs.mstrhakr.com/docs/getting-started.html) | Step-by-step tutorial |
| [Example Plugins](https://plugin-docs.mstrhakr.com/docs/examples.html) | Real-world plugin references |

### Core Concepts

| Topic | Description |
|-------|-------------|
| [PLG File Reference](https://plugin-docs.mstrhakr.com/docs/plg-file.html) | `.plg` installer format & metadata |
| [Page Files](https://plugin-docs.mstrhakr.com/docs/page-files.html) | Creating web UI pages (`.page` files) |
| [File System Layout](https://plugin-docs.mstrhakr.com/docs/filesystem.html) | Where plugin files live |
| [Event System](https://plugin-docs.mstrhakr.com/docs/events.html) | Responding to array and system events |
| [Plugin Command](https://plugin-docs.mstrhakr.com/docs/plugin-command.html) | Using the `plugin` CLI tool |

### UI Development

| Topic | Description |
|-------|-------------|
| [UI Development](https://plugin-docs.mstrhakr.com/docs/ui/index.html) | Overview of UI-related docs |
| [JavaScript Patterns](https://plugin-docs.mstrhakr.com/docs/ui/javascript-patterns.html) | Common jQuery patterns & AJAX |
| [Form Controls](https://plugin-docs.mstrhakr.com/docs/ui/form-controls.html) | Standard input elements and styling |
| [Tab Pages](https://plugin-docs.mstrhakr.com/docs/ui/tab-pages.html) | Multi-tab settings pages |
| [Icons & Styling](https://plugin-docs.mstrhakr.com/docs/ui/icons-and-styling.html) | FontAwesome, themes, and CSS |

### Advanced Topics

| Topic | Description |
|-------|-------------|
| [Advanced Topics](https://plugin-docs.mstrhakr.com/docs/advanced/index.html) | Advanced plugin development guidance |
| [Docker Integration](https://plugin-docs.mstrhakr.com/docs/advanced/docker-integration.html) | Docker API & container management |
| [Update Mechanisms](https://plugin-docs.mstrhakr.com/docs/advanced/update-mechanisms.html) | Version checks and auto-updates |
| [Debugging Techniques](https://plugin-docs.mstrhakr.com/docs/advanced/debugging-techniques.html) | Logging, error handling, dev tools |
| [Testing](https://plugin-docs.mstrhakr.com/docs/advanced/testing.html) | Testing strategies and tools |

### Distribution

| Topic | Description |
|-------|-------------|
| [Distribution & Publishing](https://plugin-docs.mstrhakr.com/docs/distribution/index.html) | How to ship and support your plugin |
| [Community Applications](https://plugin-docs.mstrhakr.com/docs/distribution/community-applications.html) | Publishing to CA |
| [Hosting](https://plugin-docs.mstrhakr.com/docs/distribution/hosting.html) | Hosting plugin files |
| [Support](https://plugin-docs.mstrhakr.com/docs/distribution/support.html) | Supporting users |

### Reference

| Topic | Description |
|-------|-------------|
| [Plugin Command](https://plugin-docs.mstrhakr.com/docs/plugin-command.html) | Using the `plugin` CLI tool |
| [Example Plugins](https://plugin-docs.mstrhakr.com/docs/examples.html) | Links to well-documented plugins |

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

See [Event System](docs/events.html) for full details.

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

<a href="https://github.com/docs/mstrhakr/plugin-docs"><img src="assets/images/logos/GitHub%20Logos/GitHub_Invertocat_White.svg" alt="GitHub" height="48" align="right"></a>

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

- [Community Applications Plugin](https://github.com/docs/Squidly271/community.applications) - The app store for plugins
- [Dynamix Plugins](https://github.com/docs/bergware/dynamix) - Reference implementations by @bonienl
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
