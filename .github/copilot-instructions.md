# Copilot Instructions for unraid-plugin-docs

This is a Jekyll documentation site for Unraid plugin development, hosted on GitHub Pages using the [just-the-docs](https://just-the-docs.github.io/just-the-docs/) theme.

## Project Structure

```
docs/           # Markdown documentation files (the main content)
_config.yml     # Jekyll configuration (theme, navigation, collections)
index.md        # Homepage with Jekyll front matter
Gemfile         # Ruby dependencies (jekyll ~> 4.3, just-the-docs ~> 0.8)
```

## Documentation Conventions

### Front Matter for Doc Pages
All pages in `docs/` should have front matter. The just-the-docs theme uses `nav_order` for menu position:

```yaml
---
layout: default
title: Page Title
nav_order: 3
---
```

### Markdown Style
- Use `#` for the main title (matches `title` in front matter)
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

## Adding New Documentation Pages

1. Create `docs/new-topic.md` with proper front matter
2. Add to navigation in the appropriate section (see `index.md` links)
3. Cross-reference from related pages
4. Include working code examples from real plugins like `dynamix.*` or `compose.manager`

## External References

Link to real plugin repositories for complex examples:
- [Dynamix plugins](https://github.com/unraid/dynamix) - Official reference implementation
- [Community Applications](https://github.com/Squidly271/community.applications) - Complex PHP patterns
- [Compose Manager](https://github.com/dcflachs/compose_plugin) - Docker integration patterns
