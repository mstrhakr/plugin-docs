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
- [Compose Manager](https://github.com/dcflachs/compose_plugin) - Docker integration patterns
