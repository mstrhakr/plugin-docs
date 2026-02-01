---
layout: default
title: CSRF Tokens
parent: Core Concepts
nav_order: 3
---

# CSRF Tokens

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Cross-Site Request Forgery (CSRF) protection is mandatory for all form submissions in Unraid. Every POST request must include a valid CSRF token.

## Accessing the CSRF Token

```php
<?
// The CSRF token is available in the $var array
global $var;
$csrf_token = $var['csrf_token'];
?>
```

## Using CSRF Tokens in Forms

```html
<form method="POST" action="/update.php">
    <input type="hidden" name="csrf_token" value="<?=$var['csrf_token']?>">
    <!-- Your form fields -->
    <input type="submit" value="Save">
</form>
```

## AJAX Requests

```javascript
// Include CSRF token in AJAX requests
$.post('/plugins/yourplugin/update.php', {
    csrf_token: '<?=$var["csrf_token"]?>',
    setting: value
});
```

## Validating CSRF Tokens

TODO: Document server-side validation patterns

```php
<?
// Example validation (document actual Unraid patterns)
if ($_POST['csrf_token'] !== $var['csrf_token']) {
    die("Invalid CSRF token");
}
?>
```

## Common Errors

TODO: Document common CSRF-related errors and solutions

## Related Topics

- [Form Controls]({% link docs/ui/form-controls.md %})
- [JavaScript Patterns]({% link docs/ui/javascript-patterns.md %})
- [Input Validation]({% link docs/security/input-validation.md %})
