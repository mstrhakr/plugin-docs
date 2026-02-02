# Copilot Instructions for plugin-docs

This is a Jekyll documentation site for Unraid® plugin development, hosted on GitHub Pages using the [just-the-docs](https://just-the-docs.github.io/just-the-docs/) theme.

> **Trademark Notice:** Unraid® is a registered trademark of Lime Technology, Inc. This project is not affiliated with, endorsed by, or sponsored by Lime Technology, Inc.

## Related Projects

This workspace may include:
- **plugin-docs** ([mstrhakr/plugin-docs](https://github.com/mstrhakr/plugin-docs)) - Documentation repository (this site)
- **compose_plugin** ([mstrhakr/compose_plugin](https://github.com/mstrhakr/compose_plugin), `dev` branch) - Refactored fork with modern patterns, real-world reference implementation

When working across both projects:
- Use compose_plugin (`dev` branch) as the primary reference for implementation patterns
- The compose_plugin is a refactored version with UX improvements over the original dcflachs/compose_plugin
- Update documentation when discovering new patterns or techniques
- Validate documentation against real plugin code
- Both repos are owned by mstrhakr

## Documentation Conventions

- All pages in `docs/` need YAML front matter with `layout: default`, `title`, and `nav_order`
- Internal links use relative paths without leading slash (e.g., `plg-file.md`)
- Code blocks need language hints for syntax highlighting
- Include explanatory text before code snippets, not just code comments
- Use "Unraid®" with the registered trademark symbol at first mention in each document

## Key Unraid® Concepts

| Concept | Key Points |
|---------|-----------|
| **PLG files** | XML plugin installers with DOCTYPE entities, FILE elements |
| **Page files** | `.page` files with header/content separator `---` |
| **Events** | Scripts in `event/` directory, blocking behavior warning |
| **Persistence** | `/boot/config/plugins/` survives reboot; `/usr/local/emhttp/` is RAM |
| **Settings** | Config files use `key="value"` format, read with `parse_plugin_cfg()` |
| **Docker Labels** | Unraid®-specific labels for webui integration (`net.unraid.docker.*`) |

## compose_plugin Reference Structure

```
compose_plugin/source/compose.manager/
├── *.page files        # UI pages (Menu placement, conditional display)
├── default.cfg         # Default configuration values
├── event/              # Array start/stop handlers
├── php/                # Backend logic and AJAX handlers
├── scripts/            # Shell scripts for compose operations
└── patches/            # Version-specific WebUI patches
```

## Working with Both Repositories

1. **Look up patterns**: Check compose_plugin for real-world examples
2. **Validate docs**: Ensure documentation matches actual plugin behavior
3. **Update docs**: Add new patterns discovered in compose_plugin
4. **Test examples**: Code snippets should be validated against compose_plugin

## External References

- [Dynamix plugins](https://github.com/unraid/dynamix) - Official reference implementation
- [Community Applications](https://github.com/Squidly271/community.applications) - Complex PHP patterns
- [Compose Manager (original)](https://github.com/dcflachs/compose_plugin) - Original Docker integration patterns
- [Compose Manager (mstrhakr fork)](https://github.com/mstrhakr/compose_plugin/tree/dev) - Refactored version with UX improvements

