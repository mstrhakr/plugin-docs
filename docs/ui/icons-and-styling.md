---
layout: default
title: Icons and Styling
parent: UI Development
nav_order: 3
---

# Icons and Styling

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Unraid uses Font Awesome icons and has built-in CSS classes for consistent styling across the UI.

{: .placeholder-image }
> 📷 **Screenshot needed:** *Unraid sidebar showing menu sections*
>
> ![Sidebar icons](../../assets/images/screenshots/sidebar-menu.png)

## Font Awesome Icons

Unraid includes Font Awesome 4.x. Use icons with the `<i>` tag and the `fa` prefix followed by the icon name. These icons work throughout your plugin UI for buttons, status indicators, and menu items.

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

TODO: Document status indicator classes

```html
<!-- Online/running status -->
<span class="status online">Running</span>

<!-- Offline/stopped status -->
<span class="status offline">Stopped</span>

<!-- Warning status -->
<span class="status warning">Degraded</span>
```

## Button Classes

Unraid styles standard HTML buttons automatically. For `<input type="button">` and `<input type="submit">` elements, no additional classes are needed. The framework applies consistent styling that matches the Unraid theme.

```html
<!-- Standard button -->
<input type="button" value="Apply">

<!-- Styled buttons (if available) -->
<button class="btn">Default</button>
<button class="btn primary">Primary</button>
<button class="btn danger">Danger</button>
```

## Color Variables

TODO: Document available CSS color variables for theming

{: .placeholder-image }
> 📷 **Screenshot needed:** *Plugin page in light vs dark theme*
>
> ![Theme comparison](../../assets/images/screenshots/theme-comparison.png)

```css
/* Example color usage */
.my-element {
    color: var(--text-color);
    background: var(--background-color);
    border-color: var(--border-color);
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

TODO: Document available utility classes

```html
<!-- Text alignment -->
<div class="text-center">Centered text</div>
<div class="text-right">Right-aligned text</div>

<!-- Margins/padding -->
<div class="mt-1">Margin top</div>
```

## Theme Compatibility

Unraid supports multiple themes. Ensure your styling works with:
- Default (light) theme
- Dark theme
- Custom community themes

Tips for theme compatibility:
- Use CSS variables when available
- Avoid hardcoded colors
- Test with multiple themes

## Custom CSS

Add custom styles in your page file:

```php
<style>
.yourplugin-container {
    padding: 10px;
    border: 1px solid var(--border-color, #ccc);
}

.yourplugin-status {
    font-weight: bold;
}

.yourplugin-status.running {
    color: green;
}

.yourplugin-status.stopped {
    color: red;
}
</style>
```

## Related Topics

- [Form Controls]({% link docs/ui/form-controls.md %})
- [Page Files]({% link docs/page-files.md %})
- [Dashboard Tiles]({% link docs/ui/dashboard-tiles.md %})

## References

- [Font Awesome Icons](https://fontawesome.com/v4/icons/) - Icon reference (check Unraid's version)
