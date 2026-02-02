---
layout: default
title: Icons and Styling
parent: UI Development
nav_order: 3
---

# Icons and Styling

{: .note }
> ✅ **Validated against Unraid 7.2.3** — CSS classes, color variables, and icon references verified from `/usr/local/emhttp/webGui/styles/`.

## Overview

Unraid® uses Font Awesome 4.7.0 icons and provides built-in CSS classes for consistent styling across the UI. The framework includes comprehensive color variables, utility classes, and status indicators that adapt to theme changes.

## Font Awesome Icons

Unraid® includes **Font Awesome 4.7.0**. Use icons with the `<i>` tag and the `fa` prefix followed by the icon name. These icons work throughout your plugin UI for buttons, status indicators, and menu items.

```html
<i class="fa fa-cog"></i> Settings
<i class="fa fa-play"></i> Start
<i class="fa fa-stop"></i> Stop
<i class="fa fa-refresh"></i> Refresh
<i class="fa fa-trash"></i> Delete
<i class="fa fa-download"></i> Download
<i class="fa fa-upload"></i> Upload
<i class="fa fa-check"></i> Success
<i class="fa fa-times"></i> Error
<i class="fa fa-warning"></i> Warning
```

### Icon Size Modifiers

Font Awesome provides size classes:

| Class | Size |
|-------|------|
| `.fa-lg` | 1.33em (33% larger) |
| `.fa-2x` | 2em |
| `.fa-3x` | 3em |
| `.fa-4x` | 4em |
| `.fa-5x` | 5em |
| `.fa-fw` | Fixed width (1.286em) |

```html
<i class="fa fa-cog fa-2x"></i>    <!-- 2x size -->
<i class="fa fa-cog fa-fw"></i>    <!-- Fixed width for alignment -->
```

### Icon Animations

```html
<i class="fa fa-spinner fa-spin"></i>   <!-- Continuous rotation -->
<i class="fa fa-spinner fa-pulse"></i>  <!-- 8-step rotation -->
```

### Icon Transformations

```html
<i class="fa fa-cog fa-rotate-90"></i>   <!-- 90° rotation -->
<i class="fa fa-cog fa-rotate-180"></i>  <!-- 180° rotation -->
<i class="fa fa-cog fa-rotate-270"></i>  <!-- 270° rotation -->
<i class="fa fa-cog fa-flip-horizontal"></i>  <!-- Horizontal flip -->
<i class="fa fa-cog fa-flip-vertical"></i>    <!-- Vertical flip -->
```

## Page Icons

In your `.page` file header, specify an icon using the `Icon` attribute. Use the icon name without the `fa-` prefix—Unraid adds it automatically. The icon appears next to your plugin's name in the menu.

```
Menu="Settings"
Title="My Plugin"
Icon="cog"
```

Common icons for plugin pages:
- `cog` - Settings
- `puzzle-piece` - Plugins
- `docker` - Docker-related
- `folder` - File/share management
- `server` - Server/hardware
- `shield` - Security

## Status Indicators

Unraid® provides status orb classes for visual state indication:

### Status Orbs

Use these classes to show colored status indicators:

| Class | Color Variable | Use Case |
|-------|----------------|----------|
| `.green-orb` | `--green-200` | Running, online, healthy |
| `.grey-orb` | `--gray-300` | Stopped, inactive |
| `.blue-orb` | `--blue-700` | Info, standby |
| `.yellow-orb` | `--orange-200` | Warning, attention needed |
| `.red-orb` | `--red-500` | Error, critical |

```html
<i class="fa fa-circle green-orb"></i> Running
<i class="fa fa-circle grey-orb"></i> Stopped
<i class="fa fa-circle yellow-orb"></i> Warning
<i class="fa fa-circle red-orb"></i> Error
```

### Text Color Classes

Apply semantic colors to text:

| Class | Description |
|-------|-------------|
| `.green-text` | Success/running text |
| `.red-text` | Error/stopped text |
| `.orange-text` | Warning text |
| `.blue-text` | Info/link text |
| `.grey-text` | Muted/disabled text |

```html
<span class="green-text">Container running</span>
<span class="red-text">Service stopped</span>
<span class="orange-text">Needs attention</span>
```

### Status Table Classes

For status tables, use these specialized classes:

```html
<table class="disk_status">...</table>   <!-- Disk status display -->
<table class="array_status">...</table>  <!-- Array status display -->
<table class="share_status">...</table>  <!-- Share status display -->
```

### Error and Warning Elements

```html
<span class="error">Error message</span>
<span class="status">Status text</span>
<div class="warning">Warning content</div>
```

## Button Classes

Unraid® styles standard HTML buttons automatically. For `<input type="button">` and `<input type="submit">` elements, no additional classes are needed. The framework applies consistent styling that matches the Unraid® theme.

```html
<!-- Standard button (auto-styled) -->
<input type="button" value="Apply">
<input type="submit" value="Save">

<!-- Link styled as button -->
<a class="button">Button Link</a>

<!-- Small button variant -->
<div class="button-small">
    <a class="button">Small Button</a>
</div>
```

{: .note }
> Buttons automatically receive hover and disabled states. Use the `disabled` attribute for inactive buttons.

## Color Variables

Unraid® 7.x provides a comprehensive color palette via CSS custom properties. These variables automatically adapt to theme changes.

### Base Colors

| Variable | Description |
|----------|-------------|
| `--black` | Pure black with opacity variants (`--black-10` through `--black-90`) |
| `--white` | Pure white with opacity variants (`--white-10` through `--white-90`) |

### Gray Scale

| Variable | Hex Value |
|----------|-----------|
| `--gray-000` | `#fafafa` |
| `--gray-100` | `#f2f2f2` |
| `--gray-200` | `#dfdfdf` |
| `--gray-300` | `#b9b9b9` |
| `--gray-400` | `#999999` |
| `--gray-500` | `#7c7c7c` |
| `--gray-600` | `#606060` |
| `--gray-700` | `#474747` |
| `--gray-800` | `#2b2b2b` |
| `--gray-900` | `#1a1a1a` |

### Brand Colors

| Variable | Hex Value | Description |
|----------|-----------|-------------|
| `--orange-500` | `#ff8c2f` | **Unraid® Brand Orange** |
| `--red-500` | `#e22828` | **Unraid® Brand Red** |

### Semantic Color Ranges

Each color has variants from 100 (lightest) to 900 (darkest):

**Orange** (warning, brand accents):
- `--orange-100` through `--orange-900`

**Red** (errors, danger, critical):
- `--red-100` through `--red-900`

**Green** (success, running, healthy):
- `--green-100` through `--green-900`

**Blue** (info, links, selected):
- `--blue-100` through `--blue-900`

**Yellow** (caution, attention):
- `--yellow-100` through `--yellow-500`

### Usage Example

```css
.myplugin-status {
    color: var(--green-500);
    background: var(--gray-100);
    border: 1px solid var(--gray-300);
}

.myplugin-error {
    color: var(--red-500);
    background: var(--red-100);
}

.myplugin-warning {
    color: var(--orange-500);
}
```

## Table Styling

Apply the `unraid` class to tables for consistent styling with alternating row colors, proper borders, and theme-compatible colors. Use standard `<thead>` and `<tbody>` structure for proper header styling.

```html
<table class="unraid">
    <thead>
        <tr>
            <th>Column 1</th>
            <th>Column 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Data 1</td>
            <td>Data 2</td>
        </tr>
    </tbody>
</table>
```

## Utility Classes

Unraid® provides Tailwind-inspired utility classes for common layout and styling needs.

### Text Alignment

| Class | Effect |
|-------|--------|
| `.text-center` | Center-aligned text |
| `.text-left` | Left-aligned text |
| `.text-right` | Right-aligned text |
| `.text-justify` | Justified text |

### Text Wrapping

| Class | Effect |
|-------|--------|
| `.text-wrap` | Normal wrapping |
| `.text-nowrap` | No wrapping |
| `.text-balance` | Balanced line lengths |
| `.text-pretty` | Pretty text wrapping |

### Display

| Class | Effect |
|-------|--------|
| `.hidden` | `display: none` |
| `.inline-block` | `display: inline-block` |

### Flexbox Containers

| Class | Effect |
|-------|--------|
| `.flex` | `display: flex` |
| `.inline-flex` | `display: inline-flex` |
| `.flex-wrap` | `flex-wrap: wrap` |
| `.flex-nowrap` | `flex-wrap: nowrap` |
| `.flex-col` | `flex-direction: column` |
| `.flex-row` | `flex-direction: row` |
| `.flex-col-reverse` | `flex-direction: column-reverse` |
| `.flex-row-reverse` | `flex-direction: row-reverse` |
| `.flex-shrink-0` | `flex-shrink: 0` |

### Flexbox Alignment

| Class | Effect |
|-------|--------|
| `.justify-start` | `justify-content: flex-start` |
| `.justify-end` | `justify-content: flex-end` |
| `.justify-center` | `justify-content: center` |
| `.justify-between` | `justify-content: space-between` |
| `.justify-around` | `justify-content: space-around` |
| `.items-center` | `align-items: center` |
| `.items-start` | `align-items: flex-start` |
| `.items-end` | `align-items: flex-end` |
| `.items-stretch` | `align-items: stretch` |
| `.items-baseline` | `align-items: baseline` |

### Gap Utilities

| Class | Size |
|-------|------|
| `.gap-1` through `.gap-8` | Gap between flex/grid items |
| `.gap-x-1` through `.gap-x-4` | Horizontal gap |
| `.gap-y-1` through `.gap-y-4` | Vertical gap |

### Input Width Classes

| Class | Use Case |
|-------|----------|
| `.narrow` | Narrow input field |
| `.trim` | Trimmed width input |

### Usage Example

```html
<div class="flex justify-between items-center gap-2">
    <span class="text-left">Label</span>
    <input type="text" class="narrow">
</div>

<div class="flex flex-col gap-1">
    <div>Item 1</div>
    <div>Item 2</div>
</div>
```

## Theme Compatibility

Unraid® supports multiple themes. Ensure your styling works with:
- Default (light) theme
- Dark theme
- Custom community themes

Tips for theme compatibility:
- **Use CSS variables** from the color palette instead of hardcoded hex values
- **Test with multiple themes** before releasing your plugin
- **Avoid `!important`** which can break theme overrides
- **Use semantic classes** like `.green-orb` instead of custom colors

## Custom CSS

### Namespace Your Class Names

Unraid's core pages use common class names with unscoped jQuery selectors. If your plugin uses the same class names, Unraid's JavaScript may inadvertently modify your elements, causing visual glitches.

Always prefix your CSS classes with your plugin name:

| Generic (avoid) | Namespaced (use) |
|-----------------|------------------|
| `.sortable` | `.myplugin-sortable` |
| `.updatecolumn` | `.myplugin-updatecolumn` |
| `.container` | `.myplugin-container` |
| `.status` | `.myplugin-status` |

This is especially important when adding tabs to existing Unraid pages like the Docker menu, where your tab's DOM shares the page with Unraid's JavaScript.

### Adding Custom Styles

Add custom styles in your page file using the validated color variables:

```php
<style>
.yourplugin-container {
    padding: 10px;
    border: 1px solid var(--gray-300);
    background: var(--gray-000);
}

.yourplugin-status {
    font-weight: bold;
}

.yourplugin-status.running {
    color: var(--green-500);
}

.yourplugin-status.stopped {
    color: var(--red-500);
}

.yourplugin-status.warning {
    color: var(--orange-500);
}
</style>
```

## Related Topics

- [Form Controls]({% link docs/ui/form-controls.md %})
- [Page Files]({% link docs/page-files.md %})
- [Dashboard Tiles]({% link docs/ui/dashboard-tiles.md %})

## References

- [Font Awesome 4.7.0 Icons](https://fontawesome.com/v4/icons/) - Complete icon reference
- [Font Awesome 4.7.0 Examples](https://fontawesome.com/v4/examples/) - Usage examples and animations
