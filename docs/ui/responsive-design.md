---
layout: default
title: Responsive Design
parent: UI Development
nav_order: 6
---

# Responsive Design for Unraid 7.2+

{: .note }
> ⚠️ **Unraid 7.2 Changes** - The WebGUI was refactored in Unraid 7.2 to support responsive CSS. This page covers the changes and how to ensure your plugin works correctly.

## Why Responsive?

In Unraid 7.2, the WebGUI was refactored to support responsive CSS:

- **Mobile & Tablet Friendly** - Manage your server from any device without pinching/zooming
- **Consistent Layouts** - Forms and tables adapt to all screen sizes
- **Modern Look & Feel** - Cleaner, more professional UI

## Critical DOM Changes

{: .warning }
> The default DOM structure has changed significantly. Previous hacks and customizations that manipulated the DOM may no longer work correctly.

### Title Bar Modifications No Longer Supported

- Adding buttons, sliders, or other elements to title bars will either not appear or display with odd spacing
- These elements will have display issues on mobile devices
- **Going forward, do not add any elements into title bars**

### Plugin Functionality Remains Intact

Even if display issues appear due to DOM changes, there should be no issues with actual plugin functionality. The responsive changes are purely visual/layout related.

## Common Bugs and Fixes

### 1. Large/Stretched Buttons

**Problem:** Buttons stretch full width or look massive.

**Why:** On desktop screens, `<dd>` uses `display: flex; flex-direction: column`. Every direct child (including buttons) becomes a flex item and stretches to fill the column.

**Before (broken):**
```markdown
_(Action)_:
: <input type="button" value="Click Me">
```

**After (fixed):**
```markdown
_(Action)_:
: <span><input type="button" value="Click Me"></span>
```

**For button groups:**

```markdown
&nbsp;
: <span class="buttons-spaced">
    <input type="submit" value="Apply">
    <input type="button" value="Done">
  </span>
```

{: .note }
> The `<span>` wrapper fix is fully backwards compatible with older Unraid versions.

### 2. Labels and Inputs Misaligned

**Problem:** Labels and inputs don't line up, or inputs appear on a new line.

**Why:** Extra spaces, tabs, or missing colons in the Markdown definition list syntax. Elements outside the `label: content` pattern aren't wrapped in `<dl>`, `<dt>`, `<dd>`.

**Fix:** Ensure proper whitespace and line breaks between each setting:

```markdown
_(Setting One)_:
: <input type="text" name="ONE">

_(Setting Two)_:
: <input type="text" name="TWO">

_(Setting Three)_:
: <input type="text" name="THREE">
```

**For elements with no label:**
```markdown
&nbsp;
: <span class="buttons-spaced">...</span>
```

### 3. Content Outside Definition Lists

**Problem:** Elements appearing outside the expected `<dl><dt><dd>` structure.

**Why:** Whitespace is critical in Unraid's Markdown parsing. The colon (`:`) must be at the start of the line, followed by a space.

**Inspect your page source** and clean up any rogue elements outside the definition structure.

## Making Wide Tables Responsive

For tables with many columns, wrap them in a `TableContainer`:

**Before:**
```html
<table>
  <thead>
    <tr><th>Col1</th><th>Col2</th><th>Col3</th><th>ColN</th></tr>
  </thead>
  <tbody>
    <tr><td>...</td><td>...</td><td>...</td><td>...</td></tr>
  </tbody>
</table>
```

**After:**
```html
<div class="TableContainer">
  <table>
    <thead>
      <tr><th>Col1</th><th>Col2</th><th>Col3</th><th>ColN</th></tr>
    </thead>
    <tbody>
      <tr><td>...</td><td>...</td><td>...</td><td>...</td></tr>
    </tbody>
  </table>
</div>
```

The `TableContainer` class:
- Sets a minimum width on the table so it doesn't shrink too small
- Enables horizontal scrolling on mobile/narrow windows
- Allows users to access all columns on any device

{: .note }
> Only wrap the immediate table element—don't nest TableContainers or wrap unrelated content. For simple/narrow tables, this wrapper is usually not needed.

## CSS Color Variables

Use CSS variables with fallbacks for theme compatibility:

```css
/* Recommended approach */
color: var(--orange-500, #FF8C2F);
background-color: var(--blue-600, #1E40AF);
border-color: var(--gray-300, #D1D5DB);
```

### Why This Matters

- **Theme Compatibility** - Your plugin automatically adapts to different themes
- **Future-Proofing** - Works with upcoming theme updates
- **Backwards Compatibility** - The fallback color works on older Unraid versions
- **Consistency** - Colors match the rest of the system

### Available Variables

Common color variables include:

- `--orange-500`, `--orange-600`, etc.
- `--blue-500`, `--blue-600`, etc.
- `--gray-100`, `--gray-200`, `--gray-300`, etc.
- `--red-500`, `--green-500`, etc.

See the [Unraid CSS documentation](https://github.com/unraid/webgui/blob/master/emhttp/plugins/dynamix/styles/themes/README.md) for the complete list.

## Footer Plugin Integration

The footer has been redesigned with responsive capabilities. Content should be added to the `.footer-right` element.

### Footer Structure

- `.footer-left` - System status and notifications (left on desktop, top on mobile)
- `.footer-right` - Copyright, links, and plugin content (right on desktop, bottom on mobile)

### Adding Content to the Footer

```javascript
// Preferred method: Use the class selector
$('.footer-right').append('<span>Your plugin content</span>');

// Legacy method (for backwards compatibility only)
$('#copyright').append('<span>Your plugin content</span>');
```

### Important Considerations

1. **No Line Breaks** - Content in `.footer-right` will never break to a new line
2. **Horizontal Scrolling** - When content overflows, the footer enables horizontal scrolling
3. **Responsive Behavior** - Mobile stacks vertically; desktop displays side-by-side
4. **Content Styling** - Added elements should use `white-space: nowrap` if text shouldn't wrap

## Block Tags and Markdown Parsing

By default, if you use a `<div>` or any block-level HTML tag in your `.page` file, the contents **will NOT** be parsed as markdown.

**Without `markdown="1"` (contents NOT parsed):**
```html
<div>
  _(This will NOT be parsed as markdown)_
  : <input type="text">
</div>
```

**With `markdown="1"` (contents ARE parsed):**
```html
<div markdown="1">
  _(This WILL be parsed as markdown inside the div)_
  : <input type="text">
</div>
```

This applies to all block-level tags (`div`, `section`, `article`, etc.).

## Version Detection

For backwards-compatible plugins, detect the Unraid version:

```php
<?
// Check if running Unraid 7.2.0-beta or higher (responsive WebGUI)
$unraidVersion = parse_ini_file('/etc/unraid-version')['version'];
$isResponsive = version_compare($unraidVersion, '7.2.0-beta', '>=');

if ($isResponsive) {
    // Use new responsive patterns
} else {
    // Use legacy patterns
}
?>
```

## Last Resort: Opting Out of Responsive Layout

{: .warning }
> This should **only** be used as a last resort when no other solution exists for severe display issues. Most problems will NOT be resolved by disabling responsive layout.

### When to Use

- Complex custom layouts that cannot be adapted to the responsive system
- You have exhausted all other solutions
- Display issues are severe enough to make your plugin unusable

### When NOT to Use

- Simply because you don't want to spend time on responsive design
- For basic button sizing issues (use `<span>` wrappers instead)
- For alignment problems (fix your markdown structure instead)
- For pages that execute code on every page or add global elements

### Option 1: Full Page Opt-Out

Add to your `.page` file header:

```ini
Title="Your Plugin"
Tag="clipboard"
Markdown="false"
ResponsiveLayout="false"
---
```

This wraps your page in `<div class="content--non-responsive">` which forces a minimum width of 1200px.

### Option 2: Selective Element Opt-Out

Wrap only problematic elements:

```html
_(Standard Setting)_:
: <input type="text" name="setting">

<div class="content--non-responsive">
  <div class="complex-custom-layout">
    <!-- Your complex layout that can't be made responsive -->
  </div>
</div>

_(Another Standard Setting)_:
: <input type="number" name="number">
```

### Limitations of Opt-Out

- Only sets a minimum width of 1200px
- Does NOT fix other display issues from DOM structure changes
- Does NOT address title bar manipulation problems
- Does NOT solve button sizing or alignment issues
- Users on mobile will have a poor experience

## Migration Summary

When updating plugins for Unraid 7.2+:

- [ ] Wrap button groups in `<span class="buttons-spaced">` (backwards compatible)
- [ ] Watch whitespace and colons—Markdown parsing is strict
- [ ] Test on mobile and desktop to catch layout issues early
- [ ] Add footer content to `.footer-right` element
- [ ] Use CSS color variables with fallbacks for theme compatibility
- [ ] Avoid manipulating title bars or other changed DOM elements
- [ ] Update custom dashboard tiles to use new `tile-header` structure
- [ ] Replace `.ctrl` with `.tile-ctrl` for dashboard controls

## Related Topics

- [Dashboard Tiles]({% link docs/ui/dashboard-tiles.md %}) - Dashboard-specific responsive patterns
- [Form Controls]({% link docs/ui/form-controls.md %}) - Form element styling
- [Page Files]({% link docs/page-files.md %}) - Page structure and headers
- [Icons and Styling]({% link docs/ui/icons-and-styling.md %}) - CSS classes and theming

---

{: .note }
> This documentation is based on the official [Responsive WebGUI Plugin Migration Guide](https://forums.unraid.net/topic/192172-responsive-webgui-plugin-migration-guide/) by **ljm42** (Unraid Administrator).
