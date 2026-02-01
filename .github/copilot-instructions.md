# Copilot Instructions for unraid-plugin-docs

This is a Jekyll documentation site for Unraid plugin development, hosted on GitHub Pages using the [just-the-docs](https://just-the-docs.github.io/just-the-docs/) theme.

## Related Projects

This workspace may include:
- **unraid-plugin-docs** ([mstrhakr/unraid-plugin-docs](https://github.com/mstrhakr/unraid-plugin-docs)) - Documentation repository (this site)
- **compose_plugin** ([mstrhakr/compose_plugin](https://github.com/mstrhakr/compose_plugin), `dev` branch) - Refactored fork with modern patterns, real-world reference implementation

When working across both projects:
- Use compose_plugin (`dev` branch) as the primary reference for implementation patterns
- The compose_plugin is a refactored version with UX improvements over the original dcflachs/compose_plugin
- Update documentation when discovering new patterns or techniques
- Validate documentation against real plugin code
- Both repos are owned by mstrhakr

## Project Structure

```
docs/           # Markdown documentation files (the main content)
_config.yml     # Jekyll configuration (theme, navigation, collections)
index.md        # Homepage with Jekyll front matter
Gemfile         # Ruby dependencies (jekyll ~> 4.3, just-the-docs ~> 0.8)
```

## Documentation Conventions

### Front Matter for Doc Pages
All pages in `docs/` must have YAML front matter. The just-the-docs theme uses these fields:

```yaml
---
layout: default
title: Page Title
nav_order: 3
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `layout` | Yes | Always use `default` |
| `title` | Yes | Appears in navigation sidebar |
| `nav_order` | Yes | Lower numbers appear higher in nav (1, 2, 3...) |
| `parent` | No | For nested pages, reference parent's `title` |

### Link Syntax
**Internal links between doc pages use relative paths without leading slash:**
```markdown
<!-- Correct - relative to current file -->
[PLG File Reference](plg-file.md)
[Getting Started](getting-started.md)

<!-- Wrong - these will break -->
[PLG File Reference](/docs/plg-file.md)
[PLG File Reference](docs/plg-file.md)
```

**Anchor links for same-page sections:**
```markdown
[See Events section](#available-events)
```

### Markdown Style
- Use `#` for the main title (should match `title` in front matter)
- Tables for reference information (attributes, commands, events)
- Code blocks with language hints: ` ```xml `, ` ```php `, ` ```bash `
- ASCII diagrams for architecture/flow concepts (see `docs/filesystem.md` for examples)
- Callouts use just-the-docs syntax: `{: .warning }` or `> ⚠️ **Note**:`

### Documenting Unraid Concepts
When documenting Unraid plugin patterns, include:
1. **What it is** - Brief explanation
2. **File/directory location** - Persistence info (USB vs RAM)
3. **Code example** - Complete, working snippet
4. **Common patterns** - Real-world usage from existing plugins

## Build & Preview

### Local Development
```bash
bundle install           # Install dependencies
bundle exec jekyll serve # Local preview at http://localhost:4000/unraid-plugin-docs/
```

### CI/CD Pipeline
GitHub Actions automatically builds and deploys on push to `main` branch (see `.github/workflows/pages.yml`):
- **Trigger**: Push to `main` or manual `workflow_dispatch`
- **Build**: Ruby 3.1, `bundle exec jekyll build`
- **Deploy**: GitHub Pages artifact deployment
- **URL**: https://mstrhakr.github.io/unraid-plugin-docs/

Pull requests to `main` should be used for changes; the site rebuilds automatically on merge.

## Key Unraid Concepts Documented

This documentation covers Unraid-specific patterns. When writing or editing:

| Concept | Key Points |
|---------|-----------|
| **PLG files** | XML plugin installers with DOCTYPE entities, FILE elements |
| **Page files** | `.page` files with header/content separator `---` |
| **Events** | Scripts in `event/` directory, blocking behavior warning |
| **Persistence** | `/boot/config/plugins/` survives reboot; `/usr/local/emhttp/` is RAM |
| **Settings** | Config files use `key="value"` format, read with `parse_plugin_cfg()` |
| **Docker Labels** | Unraid-specific labels for webui integration (`net.unraid.docker.*`) |

## Patterns from compose_plugin Reference

The compose_plugin repository demonstrates several advanced patterns:

### PLG File Patterns
- **DOCTYPE Entities** for reusable values (version, paths, URLs)
- **Pre-install scripts** for migrations and directory setup
- **Post-install scripts** for optional UI patching
- **Remove scripts** to clean up patches and packages

### Page File Patterns
- **Menu placement**: `Menu="Docker:2"` for submenu positioning
- **Conditional display**: `Cond="$var['fsState'] == 'Started' && exec('...')"`
- **Header menu items**: `Type="xmenu"` for Tasks/header bar items
- **Settings pages**: `Type="xmenu"` under `Menu="Utilities"`

### Event Handlers
- **started** - Array is fully running, start dependent services
- **stopping_docker** - Graceful shutdown of compose stacks
- Pattern: Source both default.cfg and user's .cfg file for settings

### Configuration Patterns
```ini
# default.cfg - Default values (in package)
OUTPUTSTYLE="ttyd"
PROJECTS_FOLDER="/boot/config/plugins/compose.manager/projects"

# user.cfg - User overrides (on USB flash)
PROJECTS_FOLDER="/mnt/user/appdata/compose_projects"
```

### PHP Patterns
- `parse_plugin_cfg($sName)` - Read plugin settings
- `$cfg['SETTING'] ?? 'default'` - Null coalescing for defaults
- `shell_exec("logger ...")` - Log to syslog from PHP
- Separate defines.php for constants/paths

### UI Patching (Advanced)
- Version-specific patches in `patches/6_10/`, `patches/6_11/` directories
- Use `patch -s -N -r -` with backup files
- Always provide unpatch capability

### JavaScript/UX Patterns
- **Async loading**: Load expensive data (docker commands) via AJAX after page load
- **Namespaced events**: Use `$(document).on('keydown.pluginName', ...)` to avoid event collisions
- **Debounce validation**: Delay YAML/input validation for better performance
- **Focus trapping**: Implement keyboard navigation for modals (Tab, Escape, Arrow keys)
- **XSS prevention**: Use `createTextNode()` for user/error content, never `.html()`

### Security Patterns
- Validate URLs with `filter_var($url, FILTER_VALIDATE_URL)`
- Sanitize container names with `escapeshellarg()`
- Whitelist allowed actions: `in_array($action, $allowedActions)`
- Clear cached data when stale (e.g., clear local SHA after docker pull)

### Common Bugs/Fixes (from git history)
- **Stale cache**: Clear `update-status.json` local SHA after `docker compose pull`
- **Spaces in names**: Always quote paths with `${var@Q}` in bash or `escapeshellarg()` in PHP
- **Timer collisions**: Namespace plugin timers (e.g., `composeTimers.load` not just `timers.load`)
- **Text wrapping**: Use instant toggle for view modes to prevent layout issues

## Adding New Documentation Pages

### Step-by-step process:
1. Create `docs/new-topic.md` with required front matter
2. Set `nav_order` to position it correctly (check existing pages for numbering)
3. Add cross-reference links from related pages using relative syntax
4. Update `index.md` if adding to the main navigation sections
5. Include working code examples from real plugins

### Template for new page:
```markdown
---
layout: default
title: Your Topic Title
nav_order: 10
---

# Your Topic Title

Brief introduction explaining what this topic covers.

## Section One

Content with code examples:

\`\`\`php
<?php
// Example code here
?>
\`\`\`

## Next Steps

- [Related Topic](related-topic.md)
- [Another Topic](another-topic.md)
```

### Checklist before committing:
- [ ] Front matter has `layout: default`, `title`, and `nav_order`
- [ ] Main `# heading` matches `title` in front matter
- [ ] Internal links use relative paths (e.g., `plg-file.md` not `/docs/plg-file.md`)
- [ ] Code blocks have language hints for syntax highlighting
- [ ] Tested locally with `bundle exec jekyll serve`

## External References

Link to real plugin repositories for complex examples:
- [Dynamix plugins](https://github.com/unraid/dynamix) - Official reference implementation
- [Community Applications](https://github.com/Squidly271/community.applications) - Complex PHP patterns
- [Compose Manager (original)](https://github.com/dcflachs/compose_plugin) - Original Docker integration patterns
- [Compose Manager (mstrhakr fork)](https://github.com/mstrhakr/compose_plugin/tree/dev) - Refactored version with UX improvements (workspace reference)

## compose_plugin Source Structure

When referencing compose_plugin (`dev` branch) for patterns, the key files are:

```
compose_plugin/
├── compose.manager.plg          # Main plugin installer
├── source/compose.manager/
│   ├── compose.manager.page     # Main page (Docker submenu)
│   ├── compose.manager.settings.page  # Settings (Utilities)
│   ├── Compose.page             # Header menu alternative (xmenu)
│   ├── default.cfg              # Default configuration values
│   ├── event/
│   │   ├── started              # Array start handler
│   │   └── stopping_docker      # Docker shutdown handler
│   ├── php/
│   │   ├── defines.php          # Plugin constants, paths
│   │   ├── compose_util.php     # Compose command execution
│   │   ├── util.php             # Helper functions
│   │   └── exec.php             # AJAX action handlers
│   ├── scripts/
│   │   ├── compose.sh           # Docker compose wrapper
│   │   └── patch_ui.sh          # WebUI patching script
│   └── patches/                 # Version-specific UI patches
│       ├── 6_9/
│       ├── 6_10/
│       └── 6_11/
```

## Working with Both Repositories

1. **Look up patterns**: Check compose_plugin for real-world examples
2. **Validate docs**: Ensure documentation matches actual plugin behavior
3. **Update docs**: Add new patterns discovered in compose_plugin
4. **Test examples**: Code snippets should be validated against compose_plugin
