---
layout: default
title: Dashboard Tiles
parent: UI Development
nav_order: 5
---

# Dashboard Tiles

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Plugins can add custom tiles to the Unraid dashboard to display status information, quick actions, or key metrics at a glance.

{: .placeholder-image }
> 📷 **Screenshot needed:** *Dashboard showing plugin tiles*
>
> ![Dashboard tiles](../../assets/images/screenshots/dashboard-tiles.png)

## Dashboard Tile Basics

TODO: Document the structure for adding dashboard tiles

### File Location

```
/usr/local/emhttp/plugins/yourplugin/dashboard/YourTile.page
```

### Basic Tile Structure

```php
<?
// YourTile.page
?>

Menu="Dashboard"
Title="Your Plugin Status"
Icon="your-icon"
---
<?
// PHP code for tile content
$status = getPluginStatus();
?>

<div class="dashboard-tile">
    <div class="tile-header">
        <i class="fa fa-cog"></i>
        <span>Your Plugin</span>
    </div>
    <div class="tile-content">
        <p>Status: <?=$status?></p>
    </div>
</div>
```

## Tile Types

TODO: Document different tile types available

### Status Tile

```php
<div class="dashboard-tile status-tile">
    <div class="tile-icon <?=$running ? 'online' : 'offline'?>">
        <i class="fa fa-server"></i>
    </div>
    <div class="tile-info">
        <span class="title">Service Name</span>
        <span class="status"><?=$running ? 'Running' : 'Stopped'?></span>
    </div>
</div>
```

### Metric Tile

```php
<div class="dashboard-tile metric-tile">
    <div class="metric-value">42</div>
    <div class="metric-label">Active Tasks</div>
</div>
```

### Action Tile

```php
<div class="dashboard-tile action-tile">
    <button onclick="performAction()">
        <i class="fa fa-play"></i>
        Start Service
    </button>
</div>
```

## Real-time Updates

Use nchan for live dashboard updates:

```javascript
// Subscribe to updates
var eventSource = new EventSource('/sub/yourplugin/dashboard');

eventSource.onmessage = function(event) {
    var data = JSON.parse(event.data);
    updateTile(data);
};

function updateTile(data) {
    $('.yourplugin-status').text(data.status);
    $('.yourplugin-value').text(data.value);
}
```

## Tile Sizing

TODO: Document tile size options

```css
/* Small tile */
.dashboard-tile.small {
    width: 200px;
    height: 100px;
}

/* Medium tile */
.dashboard-tile.medium {
    width: 300px;
    height: 150px;
}

/* Large tile */
.dashboard-tile.large {
    width: 400px;
    height: 200px;
}
```

## Conditional Display

Show tiles only when relevant:

```php
<?
// Only show tile if plugin is configured
$cfg = parse_plugin_cfg('yourplugin');
if (empty($cfg['enabled']) || $cfg['enabled'] !== 'yes') {
    return; // Don't render tile
}
?>

<!-- Tile content -->
```

## Dashboard Permissions

TODO: Document how to respect user permissions on dashboard tiles

## Styling Guidelines

- Match Unraid's visual style
- Use appropriate colors for status
- Keep information concise
- Ensure readability on all themes

## Best Practices

- Only show essential information
- Update in real-time when appropriate
- Provide links to full plugin pages
- Consider mobile/responsive display
- Don't overload the dashboard

## Related Topics

- [Page Files]({% link docs/page-files.md %})
- [nchan/WebSocket Integration]({% link docs/core/nchan-websocket.md %})
- [Icons and Styling]({% link docs/ui/icons-and-styling.md %})
