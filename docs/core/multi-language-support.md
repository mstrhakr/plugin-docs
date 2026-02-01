---
layout: default
title: Multi-language Support
parent: Core Concepts
nav_order: 2
---

# Multi-language Support

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Unraid supports multiple languages through a translation system. Plugins can provide localized strings using the `_()` function.

## The Translation Function

```php
<?
// Basic usage
echo _("Hello World");

// With variables (sprintf-style)
echo sprintf(_("Welcome, %s"), $username);
?>
```

## Language File Structure

TODO: Document the language file format and location

```
/usr/local/emhttp/languages/
├── en_US/
│   └── YourPlugin.txt
├── de_DE/
│   └── YourPlugin.txt
└── ...
```

## Creating Language Files

TODO: Document the format of .txt language files

```ini
; Example language file format
Hello World=Hello World
Welcome, %s=Welcome, %s
```

## Translation Best Practices

TODO: Document best practices for translatable strings

- Use descriptive keys
- Keep placeholders consistent
- Provide context comments

## Related Topics

- [Page Files]({% link docs/page-files.md %}) - UI pages where translations are used

## References

- [Dynamix language files](https://github.com/unraid/dynamix) - Examples of language file structure
