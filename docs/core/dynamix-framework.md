---
layout: default
title: Dynamix Framework
parent: Core Concepts
nav_order: 1
---

# Dynamix Framework

## Overview

The Dynamix Framework is the core PHP framework that powers the Unraid web interface. Understanding this framework is essential for plugin development as it provides access to system state, user preferences, themes, and common utilities.

## The $Dynamix Global Array

The `$Dynamix` array contains essential configuration and state information about the user's display preferences and system settings.

{: .placeholder-image }
> 📷 **Screenshot needed:** *The Unraid Display Settings page showing the various preferences that populate $Dynamix (date format, temperature scale, theme)*
>
> ![Dynamix display settings](../../assets/images/screenshots/dynamix-display-settings.png)

```php
<?
// Access the Dynamix configuration
global $Dynamix;

// Example: Check current theme
$theme = $Dynamix['theme'];
?>
```

### Complete $Dynamix Properties Reference

| Property | Type | Description | Example Values |
|----------|------|-------------|----------------|
| `theme` | string | Current UI theme name | `"black"`, `"white"`, `"gray"`, `"azure"` |
| `color` | string | Theme color variant | Theme-specific color |
| `background` | string | Background image path or empty | `""`, `/boot/config/plugins/dynamix/background.png` |
| `display['date']` | string | Date format preference | `"%Y-%m-%d"`, `"%m/%d/%Y"`, `"%d-%m-%Y"` |
| `display['time']` | string | Time format preference | `"%H:%M"` (24h), `"%I:%M %p"` (12h) |
| `display['number']` | string | Number format (decimal/thousands) | `".,"`, `",."`, `". "` |
| `display['scale']` | string | Temperature scale | `"C"` (Celsius), `"F"` (Fahrenheit) |
| `display['tabs']` | int | Tab display mode | `0` (top), `1` (bottom), `2` (none) |
| `display['resize']` | bool | Enable text area resize | `true`, `false` |
| `display['refresh']` | int | Auto-refresh interval (seconds) | `0` (disabled), `1`, `2`, etc. |
| `display['banner']` | string | Banner image path | Path or empty |
| `display['usage']` | bool | Show disk usage colors | `true`, `false` |
| `notify['normal']` | int | Normal notification setting | Bitfield for agent settings |
| `notify['warning']` | int | Warning notification setting | Bitfield for agent settings |
| `notify['alert']` | int | Alert notification setting | Bitfield for agent settings |
| `notify['position']` | string | Notification popup position | `"top-right"`, `"top-left"`, etc. |

### Accessing Display Settings

```php
<?
global $Dynamix;

// Date formatting
$dateFormat = $Dynamix['display']['date'] ?? '%Y-%m-%d';
$formattedDate = strftime($dateFormat, time());

// Time formatting  
$timeFormat = $Dynamix['display']['time'] ?? '%H:%M';
$formattedTime = strftime($timeFormat, time());

// Temperature scale
$tempScale = $Dynamix['display']['scale'] ?? 'C';
$temp = ($tempScale == 'F') ? ($celsius * 9/5 + 32) : $celsius;
$tempDisplay = $temp . "°" . $tempScale;

// Number formatting
$numberFormat = $Dynamix['display']['number'] ?? '.,';
$decimal = $numberFormat[0];
$thousands = $numberFormat[1];
$formattedNumber = number_format($value, 2, $decimal, $thousands);
?>
```

## Theme Integration

### Detecting Current Theme

{: .placeholder-image }
> 📷 **Screenshot needed:** *A plugin page shown in multiple Unraid themes (black, white, azure) demonstrating theme-aware styling*
>
> ![Theme variations](../../assets/images/screenshots/theme-variations.png)

```php
<?
global $Dynamix;

$theme = $Dynamix['theme'];
$isDarkTheme = in_array($theme, ['black', 'gray']);
?>

<style>
<?if ($isDarkTheme):?>
.my-plugin-card {
    background: #1a1a1a;
    color: #e0e0e0;
}
<?else:?>
.my-plugin-card {
    background: #ffffff;
    color: #333333;
}
<?endif;?>
</style>
```

### Theme CSS Variables

Unraid themes define CSS variables you can use for consistent styling:

```css
/* Use theme variables for consistent appearance */
.my-plugin-element {
    background-color: var(--background);
    color: var(--text);
    border-color: var(--border);
}

/* Common theme variables */
/*
--background      Main background color
--header          Header background
--menu            Menu background
--text            Primary text color
--text-secondary  Secondary text color
--border          Border color
--link            Link color
--link-hover      Link hover color
--button          Button background
--button-hover    Button hover background
--success         Success/green color
--warning         Warning/yellow color
--error           Error/red color
*/
```

### Theme-Aware Styling

```php
<?
global $Dynamix;
?>

<style>
/* Use Dynamix-provided classes */
.my-plugin-section {
    @extend .section;  /* Inherits standard section styling */
}

/* Or reference theme settings directly */
.my-custom-bg {
    background-color: <?=$Dynamix['color']?>;
}
</style>
```

## Display Modes

### Tab Display Mode

The `display['tabs']` setting controls where tabs appear:

```php
<?
global $Dynamix;

$tabMode = $Dynamix['display']['tabs'] ?? 0;
// 0 = Tabs at top
// 1 = Tabs at bottom
// 2 = Tabs hidden (dropdown only)
?>
```

### Responsive Design

```php
<?
// Check for mobile/narrow display hints in session
$isMobile = isset($_SESSION['mobile']) && $_SESSION['mobile'];
?>

<div class="my-plugin-container <?=$isMobile ? 'mobile' : 'desktop'?>">
    <!-- Content adapts to display -->
</div>
```

## Configuration Access

### Reading Unraid Settings

System settings are available via state files:

```php
<?
// Read main system variables
$var = parse_ini_file('/var/local/emhttp/var.ini');

// Read disk information  
$disks = parse_ini_file('/var/local/emhttp/disks.ini', true);

// Read share information
$shares = parse_ini_file('/var/local/emhttp/shares.ini', true);

// Read user information
$users = parse_ini_file('/var/local/emhttp/users.ini', true);

// Read network information
$network = parse_ini_file('/var/local/emhttp/network.ini', true);
?>
```

### Common $var Properties

See the complete [Var Array Reference](../reference/var-array-reference.md) for all properties.

```php
<?
global $var;

// System identification
$serverName = $var['NAME'];
$timezone = $var['timeZone'];

// Array state
$arrayState = $var['fsState'];  // Started, Stopped
$mdState = $var['mdState'];     // STARTED, STOPPED

// Unraid version
$version = $var['version'];

// Security
$csrfToken = $var['csrf_token'];
?>
```

## Path Helpers

### Standard Plugin Paths

```php
<?
// Your plugin's emhttp directory (RAM)
$emhttpDir = "/usr/local/emhttp/plugins/yourplugin";

// Your plugin's config directory (persistent on flash)
$configDir = "/boot/config/plugins/yourplugin";

// WebGui resources
$webGuiDir = "/usr/local/emhttp/webGui";

// Dynamix includes
$includesDir = "/usr/local/emhttp/webGui/include";
?>
```

### Including Dynamix Helpers

```php
<?
// Include common Dynamix utilities
require_once "/usr/local/emhttp/webGui/include/Helpers.php";

// Include translation support
require_once "/usr/local/emhttp/webGui/include/Translations.php";
?>
```

## Utility Functions

### File Size Formatting

```php
<?
// Format bytes to human-readable
function my_scale($size, $precision = 1) {
    global $Dynamix;
    $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    $unit = 0;
    while ($size >= 1024 && $unit < count($units) - 1) {
        $size /= 1024;
        $unit++;
    }
    $number = $Dynamix['display']['number'] ?? '.,';
    return number_format($size, $precision, $number[0], $number[1]) . ' ' . $units[$unit];
}
?>
```

### Time Formatting

```php
<?
// Format timestamp according to user preferences
function my_time($timestamp = null) {
    global $Dynamix;
    if ($timestamp === null) $timestamp = time();
    $format = ($Dynamix['display']['date'] ?? '%Y-%m-%d') . ' ' . 
              ($Dynamix['display']['time'] ?? '%H:%M');
    return strftime($format, $timestamp);
}
?>
```

## Loading States and Spinners

```html
<!-- Standard Dynamix loading spinner -->
<div class="spinner"></div>

<!-- Loading overlay pattern -->
<div id="loading-overlay" style="display:none;">
    <div class="spinner fixed"></div>
</div>

<script>
function showLoading() {
    $('#loading-overlay').show();
}

function hideLoading() {
    $('#loading-overlay').hide();
}
</script>
```

## Page Structure Integration

### Standard Page Template

```php
Menu="Utilities"
Title="My Plugin"
Icon="icon-myplugin"
---
<?
// Include Dynamix framework helpers
global $Dynamix;
global $var;

// Your plugin logic here
$cfg = parse_plugin_cfg("yourplugin");
?>

<div class="title">
    <span class="left">My Plugin Settings</span>
</div>

<form method="POST" action="/update.php" target="progressFrame">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    
    <dl>
        <dt>Setting:</dt>
        <dd><input type="text" name="setting" value="<?=$cfg['setting']?>"></dd>
    </dl>
    
    <dl>
        <dt>&nbsp;</dt>
        <dd><input type="submit" value="Apply"></dd>
    </dl>
</form>
```

## Related Topics

- [Plugin Settings Storage](plugin-settings-storage.md)
- [File Path Reference](../reference/file-path-reference.md)
- [Var Array Reference](../reference/var-array-reference.md)
- [Form Controls](../ui/form-controls.md)

## References

- [Dynamix plugins source](https://github.com/unraid/dynamix) - Official reference implementation
