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
> 📷 **Screenshot needed:** *The Unraid sidebar showing various plugin icons, demonstrating the icon style and sizing*
>
> ![Icons in sidebar](../../assets/images/screenshots/sidebar-icons.png)

## Font Awesome Icons

Unraid includes Font Awesome. Use icons with the `<i>` tag:

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

In your `.page` file header, specify an icon:

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

{: .placeholder-image }
> 📷 **Screenshot needed:** *Examples of Unraid's status indicators showing online (green), offline (red), and warning (yellow) states*
>
> ![Status indicators](../../assets/images/screenshots/status-indicators.png)

```html
<!-- Online/running status -->
<span class="status online">Running</span>

<!-- Offline/stopped status -->
<span class="status offline">Stopped</span>

<!-- Warning status -->
<span class="status warning">Degraded</span>
```

## Button Classes

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
> 📷 **Screenshot needed:** *Same plugin page shown in both light and dark themes, demonstrating theme-aware styling*
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
