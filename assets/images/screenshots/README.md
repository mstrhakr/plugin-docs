# Screenshots Directory

This folder contains screenshots used throughout the Unraid Plugin Development documentation.

## Contributing Screenshots

### File Naming
- Use **kebab-case** (lowercase with hyphens)
- Name based on **content**, not where it's used
- Always use `.png` format

### Image Quality
- **Width**: 1200-1400px for full-page, 600-800px for detail shots
- **Format**: PNG with reasonable compression
- **Theme**: Use dark theme for consistency (unless demonstrating themes)
- Remove any personal information before uploading

---

## Available Screenshots

These screenshots are ready to use:

| Filename | Description |
|----------|-------------|
| ✅ `plugins-installed.png` | Installed Plugins tab with plugin list |
| ✅ `plugins-installed-updateAvailable.png` | Plugins page showing update available |
| ✅ `plugins-installed-updateCheckComplete.png` | After checking for updates |
| ✅ `plugins-installed-updateComplete.png` | After completing an update |
| ✅ `plugins-install.png` | Install Plugin tab |
| ✅ `plugins-install-withUrl.png` | Install Plugin with URL entered |
| ✅ `plugins-install-withFile.png` | Install Plugin with file selected |
| ✅ `plugins-install-complete.png` | Plugin installation complete message |
| ✅ `plugins-errors.png` | Plugin File Install Errors tab |

---

## Still Needed

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `plugins-details.png` | Plugin details/info panel (click on a plugin name) | PLG File Reference |
| ⬜ | `settings-page-example.png` | A plugin settings page with form controls | Getting Started, Page Files, Form Controls |
| ⬜ | `settings-display.png` | Unraid Display Settings page | Dynamix Framework |
| ⬜ | `form-toggle.png` | Yes/No dropdown or toggle switch | Form Controls |
| ⬜ | `form-file-picker.png` | File tree picker expanded | Form Controls |
| ⬜ | `form-share-dropdown.png` | Share selector dropdown | Form Controls |
| ⬜ | `sidebar-menu.png` | Sidebar showing menu sections with plugins | Page Files, Icons & Styling |
| ⬜ | `header-menu.png` | Header bar showing Docker/VMs/custom xmenu | Page Files |
| ⬜ | `tabs-interface.png` | A plugin with multiple tabs | Tab Pages |
| ⬜ | `dashboard-tiles.png` | Dashboard with plugin tiles | Dashboard Tiles |
| ⬜ | `notifications-panel.png` | Notifications (normal/warning/alert) | Notifications System |
| ⬜ | `terminal-plugin-help.png` | Output of `plugin` command | Plugin Command |
| ⬜ | `terminal-syslog.png` | Syslog with plugin/event messages | Events, Debugging |
| ⬜ | `terminal-boot-plugins.png` | `ls /boot/config/plugins/` | File System |
| ⬜ | `terminal-emhttp-plugins.png` | `ls /usr/local/emhttp/plugins/[name]/` | File System |
| ⬜ | `devtools-network.png` | Browser DevTools Network tab | nchan/WebSocket, Debugging |
| ⬜ | `theme-comparison.png` | Light vs dark theme comparison | Icons & Styling, Dynamix |
| ⬜ | `github-release.png` | GitHub releases with .txz/.plg assets | Getting Started, Build |
| ⬜ | `github-actions.png` | GitHub Actions workflow running | Build & Packaging |
| ⬜ | `ca-browser.png` | Community Applications browser | Community Applications |
| ⬜ | `ca-plugin-icons.png` | Plugin icons in CA | Community Applications |
| ⬜ | `example-plugins.png` | Collage of popular plugin UIs | Examples |

---

## Summary

- **Available**: 8 screenshots ✅
- **Still needed**: 22 screenshots
- **Total**: 30 screenshots

---

## How Screenshots Are Used

The same screenshot can appear in multiple documentation pages. For example:
- `plugins-installed.png` → Homepage, Introduction
- `plugins-install-complete.png` → Getting Started
- `terminal-syslog.png` → Events, Debugging

## Updating the Checklist

When you add a screenshot:
1. Move it from "Still Needed" to "Available Screenshots"
2. Commit both the image and this updated README
