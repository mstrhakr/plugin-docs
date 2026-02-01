---
layout: default
title: Dynamix Framework
parent: Core Concepts
nav_order: 1
---

# Dynamix Framework

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

The Dynamix Framework is the core PHP framework that powers the Unraid web interface. Understanding this framework is essential for plugin development.

## The $Dynamix Global Array

The `$Dynamix` array contains essential configuration and state information.

```php
<?
// Example: Accessing $Dynamix
global $Dynamix;

// Common properties (document each):
// $Dynamix['theme'] - Current UI theme
// $Dynamix['display'] - Display settings
// $Dynamix['notify'] - Notification settings
?>
```

## Accessing Settings

TODO: Document how to access Unraid settings through Dynamix

## Accessing Paths

TODO: Document common path variables and helpers

## Configuration Access

TODO: Document how to read/write configuration

## Related Topics

- [Plugin Settings Storage]({% link docs/core/plugin-settings-storage.md %})
- [File Path Reference]({% link docs/reference/file-path-reference.md %})

## References

- [Dynamix plugins source](https://github.com/unraid/dynamix) - Official reference implementation
