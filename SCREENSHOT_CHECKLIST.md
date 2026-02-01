# Screenshot Checklist for Unraid Plugin Documentation

This document lists all screenshots needed for the documentation. Check off items as you capture them.

## 📁 Image Storage

All screenshots should be saved to: `assets/images/screenshots/`

**Naming convention:** `kebab-case-description.png`

**Recommended format:** PNG with reasonable compression

**Ideal dimensions:** 
- Full-page screenshots: 1200-1400px wide
- Detail/cropped screenshots: 600-800px wide
- Keep aspect ratio natural

---

## 🏠 Homepage (`index.md`)

- [ ] `unraid-plugins-overview.png` - The Unraid web interface showing the Plugins page with installed plugins and the Community Applications icon

---

## 📖 Introduction (`docs/introduction.md`)

- [ ] `plugins-page-overview.png` - The Unraid Plugins page showing installed plugins with version numbers, update status, and action buttons
- [ ] `plugin-vs-docker-comparison.png` - Side-by-side comparison showing a plugin settings page vs a Docker container management view

---

## 🚀 Getting Started (`docs/getting-started.md`)

- [ ] `hello-world-complete.png` - The completed Hello World plugin settings page in the Unraid UI, showing the message input field and Apply/Done buttons
- [ ] `page-file-rendered.png` - How a .page file renders in the Unraid Settings menu - showing the form layout, input field styling, and inline help block expanded
- [ ] `plugin-install-success.png` - The Unraid Settings sidebar showing the "Hello World" entry with its globe icon, AND/OR terminal output from a successful plugin installation
- [ ] `github-release-example.png` - GitHub releases page showing a plugin release with the .txz and .plg files attached as assets

---

## 📄 PLG File Reference (`docs/plg-file.md`)

- [ ] `plugin-manager-details.png` - The Unraid Plugin Manager showing a plugin's details panel with version, author, support link, and changelog visible
- [ ] `plugin-changelog-display.png` - The changelog/changes section displayed in the Unraid Plugin Manager when you click on a plugin's version history or info

---

## 📑 Page Files Reference (`docs/page-files.md`)

- [ ] `page-file-anatomy.png` - Annotated screenshot showing how a .page file's header attributes map to the rendered UI - showing the icon, title, and menu placement
- [ ] `menu-sections-overview.png` - The Unraid sidebar showing different menu sections (Main, Settings, Tools, Utilities) with plugin entries highlighted
- [ ] `standard-settings-page.png` - A standard settings page rendered in Unraid showing the Dynamix form styling with labels, inputs, inline help, and Default/Apply/Done buttons
- [ ] `utility-page-example.png` - A utility page in Unraid showing a custom tool interface with action buttons and output display area
- [ ] `header-xmenu-example.png` - The Unraid header bar showing an xmenu item (like Docker or VMs) with the dropdown or page it opens
- [ ] `dynamix-markdown-form.png` - A form showing the Dynamix markdown syntax rendered - labels on the left, inputs on the right, with inline help expanded

---

## 📂 File System Layout (`docs/filesystem.md`)

- [ ] `boot-config-plugins-dir.png` - Unraid terminal or file manager showing the /boot/config/plugins/ directory structure with several installed plugins
- [ ] `usb-plugins-directory.png` - File listing of /boot/config/plugins/ showing multiple plugin folders with .plg files and subdirectories
- [ ] `emhttp-plugins-directory.png` - File listing of /usr/local/emhttp/plugins/[plugin]/ showing the typical plugin structure with .page files, scripts, and php directories

---

## ⚡ Event System (`docs/events.md`)

- [ ] `event-syslog-output.png` - Syslog output showing event script execution during array start - displaying the sequence of events and plugin responses

---

## 💻 Plugin Command Reference (`docs/plugin-command.md`)

- [ ] `plugin-command-help.png` - Terminal showing the plugin command help output or a plugin installation in progress
- [ ] `plugin-install-output.png` - Terminal output showing a successful plugin installation with download progress and confirmation message

---

## 🔔 Notifications System (`docs/core/notifications-system.md`)

- [ ] `notification-levels.png` - The Unraid notification panel showing examples of normal (blue), warning (yellow), and alert (red) notifications

---

## 🎨 Dynamix Framework (`docs/core/dynamix-framework.md`)

- [ ] `dynamix-display-settings.png` - The Unraid Display Settings page showing the various preferences that populate $Dynamix (date format, temperature scale, theme)
- [ ] `theme-variations.png` - A plugin page shown in multiple Unraid themes (black, white, azure) demonstrating theme-aware styling

---

## 📡 nchan/WebSocket Integration (`docs/core/nchan-websocket.md`)

- [ ] `nchan-devtools.png` - Browser DevTools Network tab showing a WebSocket or EventSource connection to an Unraid nchan channel

---

## 🎛️ Form Controls (`docs/ui/form-controls.md`)

- [ ] `form-controls-overview.png` - An Unraid settings page showing the standard form layout with labels, inputs, and buttons styled correctly
- [ ] `toggle-switch-styles.png` - Side-by-side showing the standard Yes/No dropdown toggle and the CSS-based toggle switch in Unraid
- [ ] `share-selector-dropdown.png` - A dropdown showing Unraid shares populated from shares.ini with typical share names
- [ ] `file-tree-picker.png` - The Unraid file tree picker expanded, showing the folder hierarchy under /mnt/user/

---

## 🎨 Icons and Styling (`docs/ui/icons-and-styling.md`)

- [ ] `sidebar-icons.png` - The Unraid sidebar showing various plugin icons, demonstrating the icon style and sizing
- [ ] `status-indicators.png` - Examples of Unraid's status indicators showing online (green), offline (red), and warning (yellow) states
- [ ] `theme-comparison.png` - Same plugin page shown in both light and dark themes, demonstrating theme-aware styling

---

## 📑 Tab Pages (`docs/ui/tab-pages.md`)

- [ ] `tabbed-interface.png` - An Unraid plugin with multiple tabs visible (e.g., General, Advanced, About), showing the tab styling and content area

---

## 📊 Dashboard Tiles (`docs/ui/dashboard-tiles.md`)

- [ ] `dashboard-tiles-overview.png` - The Unraid dashboard showing various plugin tiles - including status tiles, metric displays, and action buttons
- [ ] `tile-types-examples.png` - Examples of different tile types: a status tile showing service running/stopped, a metric tile with a number, and an action tile with a button

---

## 🏪 Community Applications (`docs/distribution/community-applications.md`)

- [ ] `ca-plugin-browser.png` - The Community Applications interface showing the plugin browser with categories, search, and plugin cards
- [ ] `ca-plugin-icons.png` - Examples of good plugin icons as they appear in the CA interface - showing proper sizing and visibility

---

## 🐛 Debugging Techniques (`docs/advanced/debugging-techniques.md`)

- [ ] `browser-devtools.png` - Browser DevTools open on an Unraid plugin page, showing the Console and Network tabs for debugging
- [ ] `syslog-plugin-output.png` - Terminal showing syslog output with plugin log messages highlighted

---

## 📦 Build and Packaging (`docs/build-and-packaging.md`)

- [ ] `github-actions-build.png` - GitHub Actions workflow running for a plugin, showing the build and release steps

---

## 📚 Example Plugins (`docs/examples.md`)

- [ ] `example-plugins-collage.png` - A collage or grid showing screenshots of popular Unraid plugins (Compose Manager, User Scripts, CA, etc.) that developers can learn from

---

## 📊 Summary

| Section | Screenshots Needed |
|---------|-------------------|
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

## 📝 Tips for Capturing Screenshots

### General Tips
1. Use a clean Unraid installation or VM for consistent screenshots
2. Remove personal information from screenshots
3. Use the dark theme for consistency (or capture both if demonstrating themes)
4. Crop to focus on the relevant UI elements
5. Add annotations (arrows, boxes) sparingly and consistently

### Recommended Tools
- **Windows**: Snipping Tool, ShareX, or Greenshot
- **macOS**: Screenshot.app or CleanShot X
- **Linux**: Flameshot or Spectacle
- **Browser**: Full Page Screen Capture extension

### For Terminal Screenshots
- Use a reasonable font size (readable but not huge)
- Show enough context (command + relevant output)
- Consider using a terminal with good color support

### For Browser Screenshots
- Hide bookmarks bar for cleaner shots
- Consider using browser zoom if text is too small
- Capture at 1x scale (not zoomed/retina) for consistency

---

## ✅ When Complete

Once all screenshots are captured:
1. Place them in `assets/images/screenshots/`
2. The placeholder text will be hidden automatically (via CSS)
3. The actual images will display
4. Remove the `{: .placeholder-image }` class from the blockquotes if desired
