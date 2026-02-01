---
layout: default
title: JavaScript Patterns
parent: UI Development
nav_order: 2
---

# JavaScript Patterns

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Unraid's web UI relies heavily on jQuery for DOM manipulation and AJAX. This page documents common patterns for interactivity in plugins.

## Available Libraries

Unraid includes these JavaScript libraries by default:
- jQuery
- SweetAlert (swal)
- TODO: List other available libraries

## AJAX Form Submission

```javascript
$(function() {
    $('#myForm').on('submit', function(e) {
        e.preventDefault();
        
        $.post('/plugins/yourplugin/update.php', $(this).serialize(), function(response) {
            if (response.success) {
                // Handle success
                location.reload();
            } else {
                // Handle error
                swal('Error', response.message, 'error');
            }
        }, 'json');
    });
});
```

## Saving Settings with $.post()

```javascript
function saveSettings() {
    $.post('/update.php', {
        csrf_token: '<?=$var["csrf_token"]?>',
        setting1: $('#setting1').val(),
        setting2: $('#setting2').val()
    }, function(response) {
        // Handle response
    });
}
```

## SweetAlert Dialogs

### Simple Alert

```javascript
swal('Title', 'Message text', 'info');
// Types: 'success', 'error', 'warning', 'info'
```

### Confirmation Dialog

```javascript
swal({
    title: 'Are you sure?',
    text: 'This action cannot be undone.',
    type: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, do it!'
}, function(confirmed) {
    if (confirmed) {
        // User clicked confirm
        performAction();
    }
});
```

### Input Dialog

```javascript
swal({
    title: 'Enter value',
    type: 'input',
    showCancelButton: true,
    inputPlaceholder: 'Enter something...'
}, function(inputValue) {
    if (inputValue === false) return; // Cancelled
    if (inputValue === '') {
        swal.showInputError('Please enter a value');
        return false;
    }
    // Use inputValue
});
```

## Dynamic Content Loading

```javascript
function loadStatus() {
    $.get('/plugins/yourplugin/status.php', function(html) {
        $('#status-container').html(html);
    });
}

// Refresh every 5 seconds
setInterval(loadStatus, 5000);
```

## Toggle Visibility

```javascript
// Show/hide based on select value
$('#enableFeature').on('change', function() {
    if ($(this).val() === 'yes') {
        $('#featureOptions').show();
    } else {
        $('#featureOptions').hide();
    }
}).trigger('change'); // Initialize on page load
```

## Inline Script in Page Files

```php
<?
// Your PHP code
$setting = $cfg['setting'];
?>

<script>
$(function() {
    // jQuery code here
    var setting = '<?=addslashes($setting)?>';
    
    $('#button').on('click', function() {
        $.post('/update.php', {
            csrf_token: '<?=$var["csrf_token"]?>',
            action: 'dosomething'
        });
    });
});
</script>
```

## Event Handlers

```javascript
// Document ready
$(function() {
    // Code here runs when DOM is ready
});

// Button click
$('#myButton').on('click', function(e) {
    e.preventDefault();
    // Handle click
});

// Form change
$('input, select').on('change', function() {
    // Mark form as dirty
    $('#apply').prop('disabled', false);
});
```

## Error Handling

```javascript
$.ajax({
    url: '/plugins/yourplugin/action.php',
    method: 'POST',
    data: { csrf_token: '<?=$var["csrf_token"]?>' },
    success: function(response) {
        // Handle success
    },
    error: function(xhr, status, error) {
        swal('Error', 'Request failed: ' + error, 'error');
    }
});
```

## Best Practices

- Always include CSRF token in POST requests
- Use proper error handling
- Provide user feedback for actions
- Avoid blocking UI during long operations
- Clean up intervals/timeouts when appropriate

## Related Topics

- [CSRF Tokens]({% link docs/core/csrf-tokens.md %})
- [Form Controls]({% link docs/ui/form-controls.md %})
- [nchan/WebSocket Integration]({% link docs/core/nchan-websocket.md %})
