# Screenshots Directory

This folder contains screenshots used throughout the Unraid Plugin Development documentation.

## Contributing Screenshots

When adding screenshots, please follow these guidelines:

### File Naming
- Use **kebab-case** (lowercase with hyphens): `plugin-manager-details.png`
- Use descriptive names that match the list below
- Always use `.png` format

### Image Quality
- **Width**: 1200-1400px for full-page, 600-800px for detail shots
- **Format**: PNG with reasonable compression
- **Theme**: Use dark theme for consistency (unless demonstrating themes)
- Remove any personal information before uploading

### Tips
- Use a clean Unraid installation or VM
- Crop to focus on relevant UI elements
- Add annotations (arrows, boxes) sparingly if needed

---

## Required Screenshots

Check off items as you add them. The filename must match exactly for the documentation to display it correctly.

### Homepage
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `unraid-plugins-overview.png` | The Unraid web interface showing the Plugins page with installed plugins and the Community Applications icon |

### Introduction (`docs/introduction.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `plugins-page-overview.png` | The Unraid Plugins page showing installed plugins with version numbers, update status, and action buttons |
| ⬜ | `plugin-vs-docker-comparison.png` | Side-by-side comparison showing a plugin settings page vs a Docker container management view |

### Getting Started (`docs/getting-started.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `hello-world-complete.png` | The completed Hello World plugin settings page in the Unraid UI, showing the message input field and Apply/Done buttons |
| ⬜ | `page-file-rendered.png` | How a .page file renders in the Unraid Settings menu - showing the form layout, input field styling, and inline help block expanded |
| ⬜ | `plugin-install-success.png` | The Unraid Settings sidebar showing a plugin entry with its icon, AND/OR terminal output from a successful plugin installation |
| ⬜ | `github-release-example.png` | GitHub releases page showing a plugin release with the .txz and .plg files attached as assets |

### PLG File Reference (`docs/plg-file.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `plugin-manager-details.png` | The Unraid Plugin Manager showing a plugin's details panel with version, author, support link, and changelog visible |
| ⬜ | `plugin-changelog-display.png` | The changelog/changes section displayed in the Unraid Plugin Manager when you click on a plugin's version history |

### Page Files Reference (`docs/page-files.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `page-file-anatomy.png` | Annotated screenshot showing how a .page file's header attributes map to the rendered UI (icon, title, menu placement) |
| ⬜ | `menu-sections-overview.png` | The Unraid sidebar showing different menu sections (Main, Settings, Tools, Utilities) with plugin entries highlighted |
| ⬜ | `standard-settings-page.png` | A standard settings page rendered in Unraid showing the Dynamix form styling with labels, inputs, inline help, and buttons |
| ⬜ | `utility-page-example.png` | A utility page in Unraid showing a custom tool interface with action buttons and output display area |
| ⬜ | `header-xmenu-example.png` | The Unraid header bar showing an xmenu item (like Docker or VMs) with the dropdown or page it opens |
| ⬜ | `dynamix-markdown-form.png` | A form showing the Dynamix markdown syntax rendered - labels on the left, inputs on the right, with inline help |

### File System Layout (`docs/filesystem.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `boot-config-plugins-dir.png` | Unraid terminal or file manager showing the /boot/config/plugins/ directory structure with several installed plugins |
| ⬜ | `usb-plugins-directory.png` | File listing of /boot/config/plugins/ showing multiple plugin folders with .plg files and subdirectories |
| ⬜ | `emhttp-plugins-directory.png` | File listing of /usr/local/emhttp/plugins/[plugin]/ showing the typical plugin structure (.page files, scripts/, php/) |

### Event System (`docs/events.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `event-syslog-output.png` | Syslog output showing event script execution during array start - displaying the sequence of events and plugin responses |

### Plugin Command Reference (`docs/plugin-command.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `plugin-command-help.png` | Terminal showing the plugin command help output or a plugin installation in progress |
| ⬜ | `plugin-install-output.png` | Terminal output showing a successful plugin installation with download progress and confirmation message |

### Notifications System (`docs/core/notifications-system.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `notification-levels.png` | The Unraid notification panel showing examples of normal (blue), warning (yellow), and alert (red) notifications |

### Dynamix Framework (`docs/core/dynamix-framework.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `dynamix-display-settings.png` | The Unraid Display Settings page showing the various preferences that populate $Dynamix (date format, temperature scale, theme) |
| ⬜ | `theme-variations.png` | A plugin page shown in multiple Unraid themes (black, white, azure) demonstrating theme-aware styling |

### nchan/WebSocket Integration (`docs/core/nchan-websocket.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `nchan-devtools.png` | Browser DevTools Network tab showing a WebSocket or EventSource connection to an Unraid nchan channel |

### Form Controls (`docs/ui/form-controls.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `form-controls-overview.png` | An Unraid settings page showing the standard form layout with labels, inputs, and buttons styled correctly |
| ⬜ | `toggle-switch-styles.png` | Side-by-side showing the standard Yes/No dropdown toggle and the CSS-based toggle switch in Unraid |
| ⬜ | `share-selector-dropdown.png` | A dropdown showing Unraid shares populated from shares.ini with typical share names |
| ⬜ | `file-tree-picker.png` | The Unraid file tree picker expanded, showing the folder hierarchy under /mnt/user/ |

### Icons and Styling (`docs/ui/icons-and-styling.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `sidebar-icons.png` | The Unraid sidebar showing various plugin icons, demonstrating the icon style and sizing |
| ⬜ | `status-indicators.png` | Examples of Unraid's status indicators showing online (green), offline (red), and warning (yellow) states |
| ⬜ | `theme-comparison.png` | Same plugin page shown in both light and dark themes, demonstrating theme-aware styling |

### Tab Pages (`docs/ui/tab-pages.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `tabbed-interface.png` | An Unraid plugin with multiple tabs visible (e.g., General, Advanced, About), showing the tab styling and content area |

### Dashboard Tiles (`docs/ui/dashboard-tiles.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `dashboard-tiles-overview.png` | The Unraid dashboard showing various plugin tiles - including status tiles, metric displays, and action buttons |
| ⬜ | `tile-types-examples.png` | Examples of different tile types: a status tile showing service running/stopped, a metric tile, and an action tile with a button |

### Community Applications (`docs/distribution/community-applications.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `ca-plugin-browser.png` | The Community Applications interface showing the plugin browser with categories, search, and plugin cards |
| ⬜ | `ca-plugin-icons.png` | Examples of good plugin icons as they appear in the CA interface - showing proper sizing and visibility |

### Debugging Techniques (`docs/advanced/debugging-techniques.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `browser-devtools.png` | Browser DevTools open on an Unraid plugin page, showing the Console and Network tabs for debugging |
| ⬜ | `syslog-plugin-output.png` | Terminal showing syslog output with plugin log messages highlighted |

### Build and Packaging (`docs/build-and-packaging.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `github-actions-build.png` | GitHub Actions workflow running for a plugin, showing the build and release steps |

### Example Plugins (`docs/examples.md`)
| Status | Filename | Description |
|:------:|----------|-------------|
| ⬜ | `example-plugins-collage.png` | A collage or grid showing screenshots of popular Unraid plugins (Compose Manager, User Scripts, CA, etc.) |

---

## Summary

| Section | Count |
|---------|:-----:|
| Homepage | 1 |
| Introduction | 2 |
| Getting Started | 4 |
| PLG File Reference | 2 |
| Page Files Reference | 6 |
| File System Layout | 3 |
| Event System | 1 |
| Plugin Command | 2 |
| Notifications System | 1 |
| Dynamix Framework | 2 |
| nchan/WebSocket | 1 |
| Form Controls | 4 |
| Icons and Styling | 3 |
| Tab Pages | 1 |
| Dashboard Tiles | 2 |
| Community Applications | 2 |
| Debugging Techniques | 2 |
| Build and Packaging | 1 |
| Example Plugins | 1 |
| **TOTAL** | **41** |

---

## How to Update This List

When you add a screenshot:
1. Change `⬜` to `✅` in the Status column
2. Commit both the image and this updated README
3. The documentation will automatically display your new screenshot

## Questions?

Open an issue on the [GitHub repository](https://github.com/mstrhakr/unraid-plugin-docs/issues) if you need clarification on any screenshot.
