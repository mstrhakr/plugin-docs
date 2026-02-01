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

## Required Screenshots

Screenshots are organized by content type. Each can be reused across multiple documentation pages.

### Unraid Plugin Pages

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ✅ | `plugins-installed.png` | Installed Plugins tab showing plugin list with names, descriptions, authors, versions, status | Homepage, Introduction |
| ⬜ | `plugins-details.png` | Plugin details/info panel showing version, author, support link, changelog | PLG File Reference |
| ⬜ | `plugins-installing.png` | Terminal or UI showing plugin installation in progress with download/extraction | Getting Started, Plugin Command |

### Settings & Forms

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `settings-page-example.png` | A typical plugin settings page with Dynamix form styling (labels, inputs, help text, buttons) | Getting Started, Page Files, Form Controls |
| ⬜ | `settings-display.png` | Unraid Display Settings page (date format, temp scale, theme options) | Dynamix Framework |
| ⬜ | `form-toggle.png` | Yes/No dropdown toggle and/or CSS toggle switch | Form Controls |
| ⬜ | `form-file-picker.png` | File tree picker expanded showing /mnt/user/ hierarchy | Form Controls |
| ⬜ | `form-share-dropdown.png` | Share selector dropdown populated with share names | Form Controls |

### Menu & Navigation

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `sidebar-menu.png` | Unraid sidebar showing menu sections (Main, Settings, Tools, Utilities) with plugin entries | Page Files, Icons & Styling |
| ⬜ | `header-menu.png` | Header bar showing xmenu items (Docker, VMs, or custom plugin) | Page Files |
| ⬜ | `tabs-interface.png` | A plugin with multiple tabs (General, Advanced, About) | Tab Pages |

### Dashboard

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `dashboard-tiles.png` | Dashboard showing plugin tiles (status, metrics, action buttons) | Dashboard Tiles |

### Notifications

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `notifications-panel.png` | Notification panel showing normal (blue), warning (yellow), alert (red) examples | Notifications System |

### Terminal / Command Line

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `terminal-plugin-help.png` | Output of `plugin` command showing help/usage | Plugin Command |
| ⬜ | `terminal-syslog.png` | Syslog output with plugin messages (logger output, event execution) | Events, Debugging |
| ⬜ | `terminal-boot-plugins.png` | File listing of /boot/config/plugins/ directory | File System |
| ⬜ | `terminal-emhttp-plugins.png` | File listing of /usr/local/emhttp/plugins/[plugin]/ structure | File System |

### Browser DevTools

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `devtools-network.png` | DevTools Network tab showing WebSocket/EventSource connection or AJAX requests | nchan/WebSocket, Debugging |

### Themes

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `theme-comparison.png` | Same plugin page in light vs dark theme (side-by-side or collage) | Icons & Styling, Dynamix Framework |

### External / GitHub

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `github-release.png` | GitHub releases page with .txz and .plg files as assets | Getting Started, Build & Packaging |
| ⬜ | `github-actions.png` | GitHub Actions workflow running (build/release steps) | Build & Packaging |

### Community Applications

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `ca-browser.png` | CA plugin browser showing categories, search, plugin cards | Community Applications |
| ⬜ | `ca-plugin-icons.png` | Plugin icons as displayed in CA (showing good icon examples) | Community Applications |

### Example Plugins

| Status | Filename | Description | Used In |
|:------:|----------|-------------|---------|
| ⬜ | `example-plugins.png` | Collage/grid of popular plugin UIs (Compose Manager, User Scripts, etc.) | Examples |

---

## Summary

| Category | Count |
|----------|:-----:|
| Unraid Plugin Pages | 3 |
| Settings & Forms | 5 |
| Menu & Navigation | 3 |
| Dashboard | 1 |
| Notifications | 1 |
| Terminal / CLI | 4 |
| Browser DevTools | 1 |
| Themes | 1 |
| External / GitHub | 2 |
| Community Applications | 2 |
| Example Plugins | 1 |
| **TOTAL** | **24** |

---

## How Screenshots Are Used

The same screenshot can appear in multiple documentation pages. For example:
- `settings-page-example.png` → Getting Started, Page Files, Form Controls
- `terminal-syslog.png` → Events, Debugging
- `plugins-installed.png` → Homepage, Introduction

This reduces the total number of screenshots needed from 41 to **24**.

---

## Updating the Checklist

When you add a screenshot:
1. Change `⬜` to `✅` in the Status column
2. Commit both the image and this updated README
3. The documentation will automatically display your new screenshot

## Questions?

Open an issue on the [GitHub repository](https://github.com/mstrhakr/unraid-plugin-docs/issues) if you need clarification.
