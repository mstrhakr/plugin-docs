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

Here's how Unraid's tab interface looks in the Plugins page:

![Tab interface example](../../assets/images/screenshots/plugins-installed.png){: .crop-pluginsInstalled-tabs }

{: .placeholder-image }
> 📷 **Screenshot needed:** *Plugin with multiple tabs showing custom plugin tabs*
>
> ![Tabbed interface](../../assets/images/screenshots/tabs-interface.png)

## Basic Tab Structure

Tabs consist of clickable tab headers and corresponding content panels. Use `data-tab` attributes to link headers with their content. Only one tab's content is visible at a time—JavaScript handles showing/hiding based on which tab is clicked.

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

This jQuery code handles tab switching. When a tab is clicked, it adds the `active` class to highlight it, hides all content panels, then shows only the panel matching the clicked tab's `data-tab` value. The first tab is activated automatically on page load.

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

Some Unraid page types support a `Tab` header attribute that enables the built-in tabbed interface. This integrates with Unraid's native tab styling rather than requiring custom tab implementation.

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

## Adding Tabs to Existing Pages

Plugins can add new tabs to existing Unraid pages (like the Docker page) using the `Menu` header in `.page` files. This creates a seamless integrated experience but requires careful attention to avoid conflicts.

![Docker page with Compose tab](../../assets/images/screenshots/docker-compose-tabs.png)
*Example: Compose Manager adds a "Compose" tab to the Docker page*

### Menu Placement

To add a tab to an existing menu, use the menu name with an optional sort order:

```
# Add to Docker page as second tab
Menu="Docker:2"
Title="Compose"
Type="php"
```

### Selector Scoping

{: .warning }
> When your plugin adds a tab to an existing Unraid page, your JavaScript will run in the same context as the parent page's JavaScript. You **must** scope your CSS selectors to avoid conflicts.

Common classes like `.auto_start`, `.advanced`, `.basic`, and `.updatecolumn` are used by multiple Unraid pages. If your plugin uses these same classes and initializes jQuery plugins on them (like `switchButton`), you'll inadvertently reinitialize or modify elements that belong to the parent page.

**Problem - Unscoped selectors:**

```javascript
// BAD - This selects ALL .auto_start on the page, including Docker tab's checkboxes
$('.auto_start').switchButton({labels_placement:'right'});

// BAD - This toggles ALL .advanced elements, affecting Docker tab too  
$('.advanced').toggle();
```

**Solution - Scope to your container:**

```javascript
// GOOD - Only select checkboxes within your plugin's table
$('#my_plugin_table .auto_start').switchButton({labels_placement:'right'});

// GOOD - Only toggle your plugin's advanced columns
$('#my_plugin_table .advanced').toggle();
```

### Use Unique Class Names

For elements that need to be globally unique (like an Advanced View toggle in the tab bar), use plugin-specific class names:

```javascript
// BAD - may conflict with Docker tab's advancedview toggle
$(".tabs").append('<span class="status"><input type="checkbox" class="advancedview"></span>');
$('.advancedview').switchButton({...});

// GOOD - unique class name avoids conflicts
$(".tabs").append('<span class="status myplugin-view-toggle"><input type="checkbox" class="myplugin-advancedview"></span>');
$('.myplugin-advancedview').switchButton({...});
```

### Initialization Timing

When adding a tab to an existing page, that page's JavaScript typically runs first and initializes its own UI components. Your plugin's async content loading can conflict if not properly scoped:

```javascript
// Load content asynchronously, then initialize
function loadMyPluginContent() {
    $.get('/plugins/myplugin/content.php', function(data) {
        $('#myplugin_content').html(data);
        
        // Initialize ONLY your plugin's elements
        $('#myplugin_content .auto_start').switchButton({...});
        $('#myplugin_content .auto_start').change(function(){
            // Handle change
        });
    });
}
```

## Related Topics

- [Page Files]({% link docs/page-files.md %})
- [Form Controls]({% link docs/ui/form-controls.md %})
- [JavaScript Patterns]({% link docs/ui/javascript-patterns.md %})
