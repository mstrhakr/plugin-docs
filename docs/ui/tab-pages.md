---
layout: default
title: Tab Pages
parent: UI Development
nav_order: 4
---

# Tab Pages

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Complex plugins often need multiple configuration sections. Unraid provides a tab interface for organizing settings into logical groups.

## Basic Tab Structure

TODO: Document the exact tab structure used in Unraid

```php
<?
// Tab page structure example
?>

<div class="tabs">
    <div class="tab" data-tab="general">General</div>
    <div class="tab" data-tab="advanced">Advanced</div>
    <div class="tab" data-tab="about">About</div>
</div>

<div class="tab-content" data-tab="general">
    <!-- General settings content -->
    <form method="POST">
        <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
        <!-- Form fields -->
    </form>
</div>

<div class="tab-content" data-tab="advanced">
    <!-- Advanced settings content -->
</div>

<div class="tab-content" data-tab="about">
    <!-- About/info content -->
</div>
```

## JavaScript for Tabs

TODO: Document the built-in tab JavaScript or provide implementation

```javascript
$(function() {
    // Tab switching
    $('.tab').on('click', function() {
        var tabId = $(this).data('tab');
        
        // Update tab state
        $('.tab').removeClass('active');
        $(this).addClass('active');
        
        // Show content
        $('.tab-content').hide();
        $('.tab-content[data-tab="' + tabId + '"]').show();
    });
    
    // Activate first tab
    $('.tab:first').click();
});
```

## Page Header with Tabs

In your `.page` file, you may be able to define tabs in the header:

```
Menu="Settings"
Title="My Plugin"
Icon="cog"
Tab="true"
```

TODO: Document actual tab header syntax

## Preserving Tab State

Save and restore the selected tab:

```javascript
$(function() {
    // Restore saved tab
    var savedTab = localStorage.getItem('yourplugin-tab');
    if (savedTab) {
        $('.tab[data-tab="' + savedTab + '"]').click();
    }
    
    // Save tab on change
    $('.tab').on('click', function() {
        localStorage.setItem('yourplugin-tab', $(this).data('tab'));
    });
});
```

## Tab-Specific Forms

Each tab can have its own form with independent submission:

```php
<div class="tab-content" data-tab="general">
    <form method="POST" action="/plugins/yourplugin/save-general.php">
        <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
        <!-- General settings -->
        <input type="submit" value="Apply">
    </form>
</div>

<div class="tab-content" data-tab="network">
    <form method="POST" action="/plugins/yourplugin/save-network.php">
        <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
        <!-- Network settings -->
        <input type="submit" value="Apply">
    </form>
</div>
```

## Multi-Page Tabs

For very large plugins, use separate `.page` files that appear as tabs:

```
# plugins/yourplugin/YourPlugin.page
Menu="Settings"
Title="My Plugin"
Icon="cog"
---

# plugins/yourplugin/YourPluginAdvanced.page
Menu="Settings:2"
Title="My Plugin Advanced"
Icon="cog"
---
```

TODO: Document the Menu numbering system for related pages

## Styling Tabs

```css
.tabs {
    display: flex;
    border-bottom: 1px solid var(--border-color);
    margin-bottom: 20px;
}

.tab {
    padding: 10px 20px;
    cursor: pointer;
    border-bottom: 2px solid transparent;
}

.tab.active {
    border-bottom-color: var(--primary-color);
    font-weight: bold;
}

.tab-content {
    display: none;
}

.tab-content.active {
    display: block;
}
```

## Best Practices

- Keep related settings together
- Use clear, descriptive tab names
- Don't create too many tabs (3-5 is usually ideal)
- Consider user workflow when ordering tabs
- Save tab state for better UX

## Related Topics

- [Page Files]({% link docs/page-files.md %})
- [Form Controls]({% link docs/ui/form-controls.md %})
- [JavaScript Patterns]({% link docs/ui/javascript-patterns.md %})
