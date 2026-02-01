---
layout: default
title: Form Controls
parent: UI Development
nav_order: 1
---

# Form Controls

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Unraid uses consistent form styling throughout its web interface. Following these patterns ensures your plugin integrates seamlessly with the Unraid look and feel.

## Basic Form Structure

```html
<form method="POST" action="/update.php">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    
    <dl>
        <dt>Setting Name:</dt>
        <dd><input type="text" name="setting" value="<?=$cfg['setting']?>"></dd>
    </dl>
    
    <dl>
        <dt>&nbsp;</dt>
        <dd><input type="submit" value="Apply"></dd>
    </dl>
</form>
```

## Text Input

```html
<dl>
    <dt>Text Setting:</dt>
    <dd>
        <input type="text" name="text_setting" value="<?=$cfg['text_setting']?>" 
               placeholder="Enter value">
    </dd>
</dl>
```

## Toggle Switch (Yes/No)

TODO: Document the standard Unraid toggle switch pattern

```html
<dl>
    <dt>Enable Feature:</dt>
    <dd>
        <select name="enabled">
            <option value="yes" <?=($cfg['enabled']=='yes')?'selected':''?>>Yes</option>
            <option value="no" <?=($cfg['enabled']=='no')?'selected':''?>>No</option>
        </select>
    </dd>
</dl>
```

## Dropdown Select

```html
<dl>
    <dt>Choose Option:</dt>
    <dd>
        <select name="option">
            <option value="opt1" <?=($cfg['option']=='opt1')?'selected':''?>>Option 1</option>
            <option value="opt2" <?=($cfg['option']=='opt2')?'selected':''?>>Option 2</option>
            <option value="opt3" <?=($cfg['option']=='opt3')?'selected':''?>>Option 3</option>
        </select>
    </dd>
</dl>
```

## Textarea

```html
<dl>
    <dt>Description:</dt>
    <dd>
        <textarea name="description" rows="5" cols="50"><?=$cfg['description']?></textarea>
    </dd>
</dl>
```

## Password Input

```html
<dl>
    <dt>Password:</dt>
    <dd>
        <input type="password" name="password" value="">
    </dd>
</dl>
```

## File/Path Input

TODO: Document path picker integration if available

```html
<dl>
    <dt>Path:</dt>
    <dd>
        <input type="text" name="path" value="<?=$cfg['path']?>" 
               placeholder="/mnt/user/...">
    </dd>
</dl>
```

## Checkbox

```html
<dl>
    <dt>Options:</dt>
    <dd>
        <label>
            <input type="checkbox" name="option1" value="yes" 
                   <?=($cfg['option1']=='yes')?'checked':''?>>
            Enable Option 1
        </label>
    </dd>
</dl>
```

## Radio Buttons

```html
<dl>
    <dt>Mode:</dt>
    <dd>
        <label>
            <input type="radio" name="mode" value="auto" 
                   <?=($cfg['mode']=='auto')?'checked':''?>>
            Automatic
        </label>
        <label>
            <input type="radio" name="mode" value="manual" 
                   <?=($cfg['mode']=='manual')?'checked':''?>>
            Manual
        </label>
    </dd>
</dl>
```

## Button Styles

```html
<!-- Standard button -->
<input type="submit" value="Apply">

<!-- Button with icon -->
<button type="submit"><i class="fa fa-save"></i> Save</button>

<!-- Danger button -->
<input type="button" value="Delete" class="danger">
```

## Help Text

TODO: Document how to add help text/tooltips to form fields

## Form Layout Classes

TODO: Document available CSS classes for form layout

## Related Topics

- [CSRF Tokens]({% link docs/core/csrf-tokens.md %})
- [JavaScript Patterns]({% link docs/ui/javascript-patterns.md %})
- [Icons and Styling]({% link docs/ui/icons-and-styling.md %})
