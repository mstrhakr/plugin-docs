---
layout: default
title: Dashboard Tiles
parent: UI Development
nav_order: 5
---

# Dashboard Tiles

{: .note }
> ⚠️ **Unraid 7.2+ Responsive Changes** - The dashboard tile structure changed significantly in Unraid 7.2. This page covers both the new responsive structure and backwards-compatible patterns.

## Overview

Plugins can add custom tiles to the Unraid dashboard to display status information, quick actions, or key metrics at a glance. Dashboard tiles appear on the main Dashboard page in a responsive grid layout.

{: .placeholder-image }
> 📷 **Screenshot needed:** *Dashboard showing plugin tiles*
>
> ![Dashboard tiles](../../assets/images/screenshots/dashboard-tiles.png)

## File Location

Dashboard tiles are `.page` files placed in a specific location:

```
/usr/local/emhttp/plugins/yourplugin/YourTile.page
```

The page header must specify `Menu="Dashboard"` to appear on the dashboard.

## Tile Header Structure (Unraid 7.2+)

{: .important }
> The dashboard DOM structure changed significantly in Unraid 7.2 with the responsive update. Previous customizations that manipulated the DOM may no longer work correctly.

### New Tile Header Structure

Unraid 7.2+ uses a flexbox-based tile header system:

```html
<tbody title='My Plugin Tile'>
  <tr>
    <td>
      <span class='tile-header'>
        <span class='tile-header-left'>
          <i class='icon-yourplugin f32'></i>
          <div class='section'>
            <h3 class='tile-header-main'>Tile Title</h3>
            <span>Subtitle text</span>
          </div>
        </span>
        <span class='tile-header-right'>
          <span class='tile-ctrl'>
            <!-- Primary control buttons (icons) -->
            <span class='fa fa-power-off hand' onclick='toggleService()'></span>
          </span>
          <span class='tile-header-right-controls'>
            <!-- Secondary control links -->
            <a href='/Settings/YourPlugin'><i class='fa fa-cog control'></i></a>
          </span>
        </span>
      </span>
    </td>
  </tr>
  <tr>
    <td>
      <!-- Tile body content goes here -->
    </td>
  </tr>
</tbody>
```

### Old Tile Structure (Pre-7.2)

For reference, the old structure used a flat layout:

```html
<tbody>
  <tr>
    <td>
      <i class='icon-yourplugin f32'></i>
      <div class='section'>Title<br>Subtitle<br></div>
      <a href='/Settings/YourPlugin'><i class='fa fa-cog control'></i></a>
      <span class='ctrl'>
        <!-- Control buttons directly in ctrl span -->
      </span>
    </td>
  </tr>
  <tr>
    <td>
      <!-- Tile content -->
    </td>
  </tr>
</tbody>
```

## Backwards-Compatible Tile Template

For plugins that need to support both old and new Unraid versions, use version detection:

```php
<?
/* Dashboard tile with backwards compatibility */
$plugin = 'yourplugin';
$cfg = parse_plugin_cfg($plugin);

// Detect responsive WebGUI (7.2.0-beta and higher)
$unraidVersion = parse_ini_file('/etc/unraid-version')['version'];
$isResponsive = version_compare($unraidVersion, '7.2.0-beta', '>=');
?>

<tbody title='<?=$plugin?>'>
  <tr>
    <td>
      <span class='tile-header'>
        <span class='tile-header-left'>
          <i class='icon-<?=$plugin?> f32'></i>
          <div class='section'>
            <? if ($isResponsive): ?>
              <!-- New responsive structure -->
              <h3 class='tile-header-main'>Your Plugin</h3>
              <span>Status: Running</span>
            <? else: ?>
              <!-- Legacy structure -->
              Your Plugin<br>
              <span>Status: Running</span><br>
            <? endif; ?>
          </div>
        </span>
        <span class='tile-header-right'>
          <span class='tile-ctrl'>
            <span class='fa fa-refresh hand' title='Refresh' onclick='refreshTile()'></span>
          </span>
          <span class='tile-header-right-controls'>
            <a href='/Settings/<?=$plugin?>'><i class='fa fa-cog control'></i></a>
          </span>
        </span>
      </span>
    </td>
  </tr>
  <tr>
    <td>
      <!-- Your tile content -->
      <div class='tile-content'>
        <p>Tile body content here</p>
      </div>
    </td>
  </tr>
</tbody>
```

## CSS Classes Reference

### Tile Header Classes

| Class | Purpose |
|-------|---------|
| `.tile-header` | Main flexbox container for the header row |
| `.tile-header-left` | Contains icon and title section |
| `.tile-header-right` | Contains control buttons and links |
| `.tile-header-main` | The main title text (use `<h3>`) |
| `.tile-ctrl` | Primary control buttons (action icons) |
| `.tile-header-right-controls` | Secondary control links (settings cog, etc.) |

### Changed Classes

| Old Class | New Class | Notes |
|-----------|-----------|-------|
| `.ctrl` | `.tile-ctrl` | Use within `.tile-header-right` |
| `span.ctrl` | `.tile-ctrl span` | Float/margin properties removed |

### New CSS Structure

```css
.tile-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: start;
  gap: 1rem;
}

.tile-header-left {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: start;
  justify-content: flex-start;
  gap: 1rem;
}

.tile-header-right {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap-reverse;
  flex-shrink: 0;
  align-items: start;
  justify-content: flex-end;
  gap: 1rem;
}

.tile-header-right-controls {
  display: inline-flex;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: center;
  justify-content: flex-end;
  gap: .5rem;
}

.tile-ctrl span {
  font-size: 2rem !important;
}
```

## Responsive Grid System

The dashboard uses CSS Grid with responsive breakpoints:

```css
div.grid {
  display: grid;
  grid-template-columns: 1fr; /* Mobile: 1 column */
  gap: 2rem;
}

@media (min-width: 768px) {
  div.grid {
    grid-template-columns: repeat(2, 1fr); /* Tablet: 2 columns */
  }
}

@media (min-width: 1600px) {
  div.grid {
    grid-template-columns: repeat(3, 1fr); /* Desktop: 3 columns */
  }
}
```

{: .important }
> **Test your tiles at all breakpoints:**
> - **Mobile:** < 768px (single column)
> - **Tablet:** 768px - 1599px (two columns)  
> - **Desktop:** ≥ 1600px (three columns)

## Theme Support

For custom themes, add dashboard-specific CSS variables:

```css
:root {
  --dashstats-pie-after-bg-color: #262626;
  --dashstats-medium-breakpoint: 768px;
  --dashstats-large-breakpoint: 1600px;
}

.Theme--gray:root {
  --dashstats-pie-after-bg-color: #3d3c3a;
}

.Theme--azure:root {
  --dashstats-pie-after-bg-color: #dcdcdc;
}

.Theme--white:root {
  --dashstats-pie-after-bg-color: #f7f9f9;
}
```

## Complete Example: Status Tile

Here's a full working example of a dashboard tile:

```php
Menu="Dashboard"
---
<?
$plugin = 'myplugin';
$cfg = parse_plugin_cfg($plugin);

// Get service status
$running = trim(shell_exec("pgrep -x myservice")) !== '';
$statusClass = $running ? 'green-text' : 'red-text';
$statusText = $running ? 'Running' : 'Stopped';

// Version detection for responsive layout
$unraidVersion = parse_ini_file('/etc/unraid-version')['version'];
$isResponsive = version_compare($unraidVersion, '7.2.0-beta', '>=');
?>

<tbody title='<?=$plugin?>'>
  <tr>
    <td>
      <span class='tile-header'>
        <span class='tile-header-left'>
          <i class='fa fa-server f32'></i>
          <div class='section'>
            <? if ($isResponsive): ?>
              <h3 class='tile-header-main'>My Service</h3>
              <span class='<?=$statusClass?>'><?=$statusText?></span>
            <? else: ?>
              My Service<br>
              <span class='<?=$statusClass?>'><?=$statusText?></span><br>
            <? endif; ?>
          </div>
        </span>
        <span class='tile-header-right'>
          <span class='tile-ctrl'>
            <? if ($running): ?>
              <span class='fa fa-stop hand red-text' title='Stop Service' 
                    onclick='stopService()'></span>
            <? else: ?>
              <span class='fa fa-play hand green-text' title='Start Service' 
                    onclick='startService()'></span>
            <? endif; ?>
            <span class='fa fa-refresh hand' title='Refresh' 
                  onclick='refreshTile()'></span>
          </span>
          <span class='tile-header-right-controls'>
            <a href='/Settings/<?=$plugin?>'><i class='fa fa-cog control'></i></a>
          </span>
        </span>
      </span>
    </td>
  </tr>
  <tr>
    <td>
      <div style='padding: 10px;'>
        <table class='tablesorter'>
          <tr>
            <td>Uptime:</td>
            <td><?=$running ? getUptime() : 'N/A'?></td>
          </tr>
          <tr>
            <td>Version:</td>
            <td><?=$cfg['VERSION'] ?? 'Unknown'?></td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</tbody>

<script>
function startService() {
  $.post('/plugins/<?=$plugin?>/include/exec.php', {action: 'start'}, function() {
    location.reload();
  });
}

function stopService() {
  $.post('/plugins/<?=$plugin?>/include/exec.php', {action: 'stop'}, function() {
    location.reload();
  });
}

function refreshTile() {
  location.reload();
}
</script>
```

## Real-time Updates with Nchan

For live dashboard updates without page refresh:

```javascript
// Subscribe to plugin updates
var eventSource = new EventSource('/sub/yourplugin/status');

eventSource.onmessage = function(event) {
  var data = JSON.parse(event.data);
  updateTileStatus(data);
};

function updateTileStatus(data) {
  $('.yourplugin-status').text(data.status);
  $('.yourplugin-status')
    .removeClass('green-text red-text')
    .addClass(data.running ? 'green-text' : 'red-text');
}
```

See [Nchan/WebSocket Integration]({% link docs/core/nchan-websocket.md %}) for details on setting up server-side events.

## Conditional Display

Show tiles only when relevant conditions are met:

```php
<?
// Only show tile if plugin is enabled
$cfg = parse_plugin_cfg('yourplugin');
if (empty($cfg['SHOW_DASHBOARD']) || $cfg['SHOW_DASHBOARD'] !== 'yes') {
  return; // Don't render tile
}

// Or check array state
if ($var['fsState'] !== 'Started') {
  return; // Only show when array is started
}
?>

<!-- Tile content renders only if conditions pass -->
```

## Migration Checklist

When updating existing dashboard tiles for Unraid 7.2+:

- [ ] Replace `.ctrl` with `.tile-ctrl` in selectors
- [ ] Update HTML to use new `tile-header` structure
- [ ] Remove any custom float or fixed width styles
- [ ] Use flexbox properties instead of floats
- [ ] Add version detection for backwards compatibility
- [ ] Test at mobile (< 768px), tablet (768-1599px), and desktop (≥ 1600px)
- [ ] Add theme-specific variables if using custom colors
- [ ] Verify controls are separated into primary (`tile-ctrl`) and secondary (`tile-header-right-controls`)

## Important Limitations

{: .warning }
> **Title Bar Modifications No Longer Supported**
> 
> Adding buttons, sliders, or other elements to title bars will either not appear or display with odd spacing. Going forward, do not add any elements into title bars.

## Best Practices

- **Keep it concise** - Dashboard tiles should show essential information at a glance
- **Use appropriate icons** - Match Unraid's visual style with Font Awesome icons
- **Test responsively** - Verify layout at all three breakpoints
- **Provide settings link** - Include a cog icon linking to full plugin settings
- **Consider themes** - Use CSS variables for colors that adapt to themes
- **Update in real-time** - Use nchan for live status updates when appropriate

## Related Topics

- [Page Files]({% link docs/page-files.md %}) - Header attributes and page structure
- [Nchan/WebSocket Integration]({% link docs/core/nchan-websocket.md %}) - Real-time updates
- [Icons and Styling]({% link docs/ui/icons-and-styling.md %}) - Font Awesome and CSS classes
- [Responsive Design]({% link docs/ui/responsive-design.md %}) - General responsive patterns

---

{: .note }
> Parts of this documentation are based on the official [Responsive WebGUI Plugin Migration Guide](https://forums.unraid.net/topic/192172-responsive-webgui-plugin-migration-guide/) by **ljm42** (Unraid Administrator).
