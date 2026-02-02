---
layout: default
title: Page Files Reference
nav_order: 4
mermaid: true
---

# Page Files Reference

{: .note }
> ✅ **Validated against Unraid 7.2.3** - Page file structure and header attributes verified against system plugins.

Page files (`.page`) are how plugins add pages to the Unraid web UI. They combine metadata headers with PHP/HTML/JavaScript content to create settings pages, tools, and dashboards.

## Basic Structure

A `.page` file has two sections separated by `---`:

```php
Menu="Settings"
Title="My Plugin"
Icon="cog"
---
<?php
// Your PHP/HTML content here
echo "Hello from My Plugin!";
?>
```

{: .placeholder-image }
> 📷 **Screenshot needed:** *A plugin settings page showing form styling*
>
> ![Page file rendered](../assets/images/screenshots/settings-page-example.png)

## Header Attributes

The header defines where and how your page appears in the Unraid menu.

### Menu Placement

| Attribute | Values | Description |
|-----------|--------|-------------|
| `Menu` | `Main`, `Settings`, `Tools`, `Utilities`, `Tasks`, `Docker`, `VMs`, `UserPreferences` | Which menu section |
| `Type` | `menu`, `xmenu`, `php` | Page type (see below) |

{: .placeholder-image }
> 📷 **Screenshot needed:** *Unraid sidebar showing menu sections*
>
> ![Menu sections](../assets/images/screenshots/sidebar-menu.png)

#### Menu Types Explained

- **`php`** - Standard page that renders PHP content
- **`menu`** - Creates a dropdown menu container (no content)
- **`xmenu`** - External/top-level menu item (header bar)

### Common Header Options

```plaintext
Menu="Settings"              # Menu section
Title="My Plugin Settings"   # Page title shown in menu
Icon="cog"                   # FontAwesome icon (without fa- prefix)
Tag="cog"                    # Alternative icon attribute
Type="php"                   # Page type
```

### Menu Position

Control ordering within a menu section:

```plaintext
Menu="Settings:50"           # Lower numbers = higher in menu
Menu="Docker:2"              # Appears second in Docker menu
```

### Conditional Display

Show/hide pages based on conditions:

```plaintext
Cond="$var['fsState'] == 'Started'"
```

Common conditions:
```php
// Only when array is started
Cond="$var['fsState'] == 'Started'"

// Only when Docker is running
Cond="exec('/etc/rc.d/rc.docker status | grep -v \"not\"')"

// Based on plugin config
Cond="file_exists('/boot/config/plugins/myplugin/enabled')"

// Check plugin setting value
Cond="exec(\"grep '^FEATURE_ENABLED=' /boot/config/plugins/myplugin/myplugin.cfg | grep 'true'\")"
```

### Additional Options

```plaintext
Tabs="true"                  # Enable tabbed interface
Code="f0db"                  # Unicode code for custom icon
Author="Your Name"           # Shows in page info
Markdown="true"              # Enable markdown processing (rarely used)
```

## Page Types

### Standard Settings Page

For a page under Settings with the standard Dynamix form styling:

```php
Menu="Settings"
Title="My Plugin"
Icon="cog"
---
<?php
$plugin = "myplugin";
$cfg = parse_plugin_cfg($plugin);
?>

<form markdown="1" method="POST" action="/update.php" target="progressFrame">
<input type="hidden" name="#file" value="<?=$plugin?>/<?=$plugin?>.cfg">

_(Setting One)_:
: <input type="text" name="SETTING_ONE" value="<?=$cfg['SETTING_ONE']?>">

<blockquote class="inline_help">
Help text for this setting.
</blockquote>

_(Setting Two)_:
: <select name="SETTING_TWO">
  <?=mk_option($cfg['SETTING_TWO'], "option1", _("Option 1"))?>
  <?=mk_option($cfg['SETTING_TWO'], "option2", _("Option 2"))?>
  </select>

<input type="submit" name="#default" value="_(Default)_">
: <input type="submit" name="#apply" value="_(Apply)_" disabled><input type="button" value="_(Done)_" onclick="done()">
</form>
```

{: .placeholder-image }
> 📷 **Screenshot needed:** *A plugin settings page showing form styling*
>
> ![Standard settings page](../assets/images/screenshots/settings-page-example.png)

### Utility Page (No Form)

For tools or dashboards:

```php
Menu="Utilities"
Title="My Tool"
Icon="wrench"
---
<?php
// Your custom PHP content
?>
<div id="myTool">
    <h2>My Utility Tool</h2>
    <button onclick="doSomething()">Run Task</button>
    <div id="output"></div>
</div>

<script>
function doSomething() {
    $.post('/plugins/myplugin/php/exec.php', {action: 'runTask'}, function(data) {
        $('#output').html(data);
    });
}
</script>
```

### Header Menu Item (xmenu)

For top-level pages in the header bar:

```php
Menu="Tasks:61"
Type="xmenu"
Title="Docker Compose"
Tag="fa-cubes"
Code="f1b3"
Cond="$var['fsState'] == 'Started'"
---
<?php
// Full page content
include '/usr/local/emhttp/plugins/myplugin/php/main.php';
?>
```

{: .placeholder-image }
> 📷 **Screenshot needed:** *Header bar showing xmenu items*
>
> ![Header menu](../assets/images/screenshots/header-menu.png)

### Nested Under Another Menu

Add your page as a tab under an existing menu section like Docker or VMs. The number after the colon controls tab order—lower numbers appear first.

```php
Menu="Docker:2"
Title="Compose"
Type="php"
---
<?php
// Content appears as tab under Docker
?>
```

## Dynamix Markdown Syntax

Unraid uses a markdown-like syntax for form fields. This is **not standard Markdown** - it's a custom format.

{: .placeholder-image }
> 📷 **Screenshot needed:** *A plugin settings page showing form styling*
>
> ![Dynamix form](../assets/images/screenshots/settings-page-example.png)

### Basic Field Structure

Dynamix uses a custom markdown-like syntax for form layouts. The `_(text)_` wrapper marks strings for translation. A colon after the label and colon-space before the input are required for proper rendering. The `inline_help` blockquote creates expandable help text.

```markdown
_(Label Text)_:
: <input element or content>

<blockquote class="inline_help">
Help text shown when user clicks help icon.
</blockquote>
```

The pattern:
- `_(text)_` - Translatable label (the underscores enable translation)
- `:` after the label
- `: ` (colon-space) before the input element

### Input Types

**Text Input:**
```markdown
_(Server Name)_:
: <input type="text" name="SERVER_NAME" value="<?=$cfg['SERVER_NAME']?>">
```

**Select Dropdown:**
```markdown
_(Log Level)_:
: <select name="LOG_LEVEL">
  <?=mk_option($cfg['LOG_LEVEL'], "debug", _("Debug"))?>
  <?=mk_option($cfg['LOG_LEVEL'], "info", _("Info"))?>
  <?=mk_option($cfg['LOG_LEVEL'], "error", _("Error"))?>
  </select>
```

**Checkbox:**
```markdown
_(Enable Feature)_:
: <select name="FEATURE_ENABLED">
  <?=mk_option($cfg['FEATURE_ENABLED'], "false", _("No"))?>
  <?=mk_option($cfg['FEATURE_ENABLED'], "true", _("Yes"))?>
  </select>
```

**Number Input:**
```markdown
_(Port Number)_:
: <input type="number" name="PORT" value="<?=$cfg['PORT']?>" min="1" max="65535">
```

**File/Path Picker:**
```markdown
_(Data Path)_:
: <input type="text" name="DATA_PATH" value="<?=$cfg['DATA_PATH']?>" data-pickroot="/mnt" data-pickfolders="true">
```

### Form Buttons

Standard button layout:

```markdown
<input type="submit" name="#default" value="_(Default)_">
: <input type="submit" name="#apply" value="_(Apply)_" disabled><input type="button" value="_(Done)_" onclick="done()">
```

- `#default` - Resets to default.cfg values
- `#apply` - Saves the settings
- `done()` - Built-in function to close/navigate back

### Multiple Buttons

```markdown
_(Actions)_:
: <input type="button" value="_(Start)_" onclick="startService()">
  <input type="button" value="_(Stop)_" onclick="stopService()">
  <input type="button" value="_(Restart)_" onclick="restartService()">
```

## Working with Configuration

### Reading Configuration

```php
<?php
$plugin = "myplugin";
$cfg = parse_plugin_cfg($plugin);  // Merges default.cfg with user config

// Access values
$setting = $cfg['MY_SETTING'];
?>
```

### Saving Configuration

The form posts to `/update.php` which handles config file updates:

```php
<form method="POST" action="/update.php" target="progressFrame">
<input type="hidden" name="#file" value="myplugin/myplugin.cfg">
<!-- form fields -->
</form>
```

### default.cfg Format

```ini
MY_SETTING="default_value"
ANOTHER_SETTING="another_default"
ENABLED="false"
```

## JavaScript Integration

### Making AJAX Calls

```php
<script>
var pluginURL = "/plugins/myplugin/php/exec.php";

function runAction() {
    $.post(pluginURL, {action: 'doSomething', param1: 'value'}, function(data) {
        console.log(data);
    });
}
</script>
```

### Including External Scripts

```php
---
<script src="<?autov('/plugins/myplugin/javascript/custom.js')?>"></script>
```

The `autov()` function adds version query strings for cache busting.

### Including Unraid's Built-in Libraries

Unraid bundles jQuery plugins and CSS for common UI patterns like switch buttons. Include these from `/webGui/` paths. The `autov()` function appends version strings for cache busting when files update.

```php
---
<link type="text/css" rel="stylesheet" href="<?autov('/webGui/styles/jquery.switchbutton.css')?>">
<script src="<?autov('/webGui/javascript/jquery.switchbutton.js')?>"></script>
```

## Common Patterns

### Settings Page with Apply/Done

```php
Menu="Settings"
Title="My Plugin"
Icon="cog"
---
<?php
$plugin = "myplugin";
$cfg = parse_plugin_cfg($plugin);
?>

<form markdown="1" method="POST" action="/update.php" target="progressFrame">
<input type="hidden" name="#file" value="<?=$plugin?>/<?=$plugin?>.cfg">
<input type="hidden" name="#command" value="/usr/local/emhttp/plugins/<?=$plugin?>/scripts/apply.sh">

_(Enable Service)_:
: <select name="ENABLED">
  <?=mk_option($cfg['ENABLED'], "false", _("No"))?>
  <?=mk_option($cfg['ENABLED'], "true", _("Yes"))?>
  </select>

<blockquote class="inline_help">
Enable or disable the service.
</blockquote>

<input type="submit" name="#default" value="_(Default)_">
: <input type="submit" name="#apply" value="_(Apply)_" disabled><input type="button" value="_(Done)_" onclick="done()">
</form>
```

### Dashboard/Status Page

```php
Menu="Utilities"
Title="My Status"
Icon="dashboard"
---
<?php
$plugin = "myplugin";
$status = shell_exec("/usr/local/emhttp/plugins/$plugin/scripts/status.sh");
?>

<div class="title">Service Status</div>
<pre><?=$status?></pre>

<button onclick="refreshStatus()">Refresh</button>

<script>
function refreshStatus() {
    $.get('/plugins/<?=$plugin?>/php/status.php', function(data) {
        $('pre').text(data);
    });
}
</script>
```

### Multi-Tab Page

```php
Menu="Settings"
Title="My Plugin"
Tabs="true"
---
<?php
$plugin = "myplugin";
$cfg = parse_plugin_cfg($plugin);

$tabbed = true;  // Signal that we're using tabs
?>

<!-- Tab: General -->
<div id="tab1" markdown="1">
_(General Setting)_:
: <input type="text" name="GENERAL" value="<?=$cfg['GENERAL']?>">
</div>

<!-- Tab: Advanced -->
<div id="tab2" markdown="1">
_(Advanced Setting)_:
: <input type="text" name="ADVANCED" value="<?=$cfg['ADVANCED']?>">
</div>
```

## PHP Functions Available

### Core Functions

```php
// Parse plugin config (merges default.cfg with user config)
$cfg = parse_plugin_cfg('myplugin');

// Create select option
mk_option($currentValue, $optionValue, $displayText);

// Translation wrapper
_('Text to translate');

// Auto-versioned URL for cache busting
autov('/path/to/file.js');

// Access system variables
$var['fsState']      // Array state: 'Started', 'Stopped'
$var['version']      // Unraid version
$display['theme']    // Current theme
```

### Docker Functions

If you include the Docker client:

```php
require_once("/usr/local/emhttp/plugins/dynamix.docker.manager/include/DockerClient.php");

$DockerClient = new DockerClient();
$containers = $DockerClient->getDockerContainers();
```

## File Locations

### Typical Plugin Structure

```
/usr/local/emhttp/plugins/myplugin/
├── myplugin.page              # Main page
├── myplugin.settings.page     # Settings page (under Settings menu)
├── default.cfg                # Default configuration
├── README.md                  # Shown in Plugin Manager
├── php/
│   ├── exec.php               # AJAX endpoint
│   └── helpers.php            # Utility functions
├── javascript/
│   └── custom.js              # Client-side scripts
├── styles/
│   └── custom.css             # Custom styling
└── event/
    └── started                # Event handlers
```

## Troubleshooting

### Page Not Appearing

1. Check Menu attribute matches a valid section
2. Verify Cond evaluation returns true
3. Check for PHP syntax errors: `php -l yourfile.page`
4. Check for Windows line endings (CRLF) - see [Debugging Techniques](advanced/debugging-techniques.md#windows-line-endings-crlf-vs-lf)

### Form Not Saving

1. Verify `#file` hidden input matches your config path
2. Check file permissions on config directory
3. Ensure form method is POST

### Styles Not Loading

1. Use `autov()` for cache busting
2. Check file paths are correct
3. Verify files exist in the package

### Content Shifted or Layout Issues

{: .warning }
> Do not use raw `<dl><dt><dd>` HTML inside `markdown="1"` forms. The Dynamix markdown processor expects the colon syntax.

**Wrong (causes layout shift):**
```html
<dl>
<dt>My Label:</dt>
<dd><input type="text" name="field"></dd>
</dl>
```

**Correct:**
```markdown
_(My Label)_:
: <input type="text" name="field">
```

The `: ` (colon-space at start of line) creates proper Dynamix field alignment. For read-only display sections outside forms, use standard HTML tables or `<pre>` blocks.

{: .note }
> See the [DocTest validation plugin](https://github.com/mstrhakr/plugin-docs/blob/main/validation/plugin/source/emhttp/DocTest.page) for a working example of proper form structure.

## Next Steps

- Learn about [Page Headers](page-headers.md) for advanced menu options
- See [Dynamix Markdown](dynamix-markdown.md) for form syntax details
- Check [PHP Integration](php-integration.md) for backend development
