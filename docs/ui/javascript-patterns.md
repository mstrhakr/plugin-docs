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

## Progress Indicators

### Simple Loading Spinner

```javascript
// Show loading state
function showLoading(container) {
    $(container).html('<div class="spinner"></div>');
}

function hideLoading(container, content) {
    $(container).html(content);
}

// Usage
showLoading('#status');
$.get('/plugins/yourplugin/status.php', function(data) {
    hideLoading('#status', data);
});
```

### Progress Bar

```html
<div id="progress-container" style="display:none;">
    <div class="progressbar">
        <div id="progress-bar" style="width:0%"></div>
    </div>
    <span id="progress-text">0%</span>
</div>

<script>
function updateProgress(percent, text) {
    $('#progress-container').show();
    $('#progress-bar').css('width', percent + '%');
    $('#progress-text').text(text || percent + '%');
}

function hideProgress() {
    $('#progress-container').hide();
}
</script>

<style>
.progressbar {
    width: 100%;
    height: 20px;
    background: #e0e0e0;
    border-radius: 10px;
    overflow: hidden;
}
.progressbar > div {
    height: 100%;
    background: #4caf50;
    transition: width 0.3s;
}
</style>
```

### Long-Running Task with Progress

```javascript
function startLongTask() {
    updateProgress(0, 'Starting...');
    
    $.post('/plugins/yourplugin/start_task.php', {
        csrf_token: '<?=$var["csrf_token"]?>'
    }, function(response) {
        if (response.taskId) {
            pollProgress(response.taskId);
        }
    }, 'json');
}

function pollProgress(taskId) {
    $.get('/plugins/yourplugin/progress.php', { taskId: taskId }, function(response) {
        updateProgress(response.percent, response.message);
        
        if (response.complete) {
            hideProgress();
            swal('Complete', 'Task finished successfully', 'success');
        } else {
            setTimeout(function() { pollProgress(taskId); }, 1000);
        }
    }, 'json');
}
```

## Modal Dialogs

### Using SweetAlert (swal)

SweetAlert is included in Unraid and provides attractive modal dialogs.

#### Basic Alerts

```javascript
// Simple alert
swal('Title', 'Message text', 'info');
// Types: 'success', 'error', 'warning', 'info'

// With custom button text
swal({
    title: 'Success!',
    text: 'Operation completed',
    type: 'success',
    confirmButtonText: 'OK'
});
```

#### Confirmation Dialog

```javascript
swal({
    title: 'Are you sure?',
    text: 'This action cannot be undone.',
    type: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#d33',
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel'
}, function(confirmed) {
    if (confirmed) {
        performDelete();
    }
});
```

#### Input Dialog

```javascript
swal({
    title: 'Enter Name',
    text: 'Please provide a name for the new item:',
    type: 'input',
    showCancelButton: true,
    inputPlaceholder: 'Item name...',
    inputValue: 'Default'
}, function(inputValue) {
    if (inputValue === false) return; // Cancelled
    if (inputValue === '') {
        swal.showInputError('Please enter a name');
        return false;
    }
    // Use inputValue
    createItem(inputValue);
});
```

#### HTML Content Dialog

```javascript
swal({
    title: 'Details',
    text: '<div style="text-align:left">' +
          '<p><strong>Name:</strong> ' + name + '</p>' +
          '<p><strong>Status:</strong> ' + status + '</p>' +
          '</div>',
    html: true
});
```

#### Loading Dialog

```javascript
// Show loading
swal({
    title: 'Processing...',
    text: 'Please wait',
    showConfirmButton: false,
    allowOutsideClick: false
});

// Close when done
doAsyncTask().then(function() {
    swal.close();
});
```

### Custom Modal

```html
<!-- Modal HTML -->
<div id="myModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2>Modal Title</h2>
        <div id="modal-body">
            <!-- Content here -->
        </div>
        <button onclick="closeModal()">Close</button>
    </div>
</div>

<style>
.modal {
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
}
.modal-content {
    background: var(--background, white);
    margin: 10% auto;
    padding: 20px;
    width: 50%;
    max-width: 600px;
    border-radius: 5px;
}
.close {
    float: right;
    font-size: 28px;
    cursor: pointer;
}
</style>

<script>
function openModal(content) {
    $('#modal-body').html(content);
    $('#myModal').fadeIn();
}

function closeModal() {
    $('#myModal').fadeOut();
}

// Close on outside click
$('#myModal').on('click', function(e) {
    if (e.target === this) closeModal();
});

// Close on Escape key
$(document).on('keydown', function(e) {
    if (e.key === 'Escape') closeModal();
});
</script>
```

## Dynamix JavaScript Functions

Unraid includes `dynamix.js` with useful utilities:

### Common Functions

```javascript
// Format file size
var size = my_scale(bytes);  // Returns "1.5 GB" etc.

// Format number according to locale
var num = my_number(value, decimals);

// Parse numbers (handles locale)
var value = my_parse_number(string);

// Done button (return to previous page)
function done() {
    // Standard Unraid done behavior
}
```

### Refresh and Reload

```javascript
// Refresh specific section
function refresh(section) {
    // Refreshes #section element
}

// Full page reload
location.reload();

// Reload with cache clear
location.reload(true);
```

## Keyboard Shortcuts

```javascript
$(document).on('keydown', function(e) {
    // Ctrl+S to save
    if (e.ctrlKey && e.key === 's') {
        e.preventDefault();
        $('#saveButton').click();
    }
    
    // Escape to close/cancel
    if (e.key === 'Escape') {
        closeModal();
    }
});
```

## Best Practices

1. **Always include CSRF token** in POST requests
2. **Use proper error handling** - show user-friendly messages
3. **Provide user feedback** - show loading states, confirmations
4. **Avoid blocking UI** during long operations - use async patterns
5. **Clean up resources** - clear intervals/timeouts, close EventSources
6. **Throttle rapid actions** - prevent double-clicks, rapid submissions
7. **Handle offline state** - graceful degradation
8. **Use consistent patterns** - match Unraid's existing UI behavior

### Preventing Double-Submit

```javascript
$('#myForm').on('submit', function(e) {
    var $button = $(this).find('input[type="submit"]');
    if ($button.data('submitting')) {
        e.preventDefault();
        return false;
    }
    $button.data('submitting', true).prop('disabled', true);
});
```

### Debouncing Input

```javascript
var debounceTimer;
$('#searchInput').on('input', function() {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(function() {
        performSearch($('#searchInput').val());
    }, 300);
});
```

## Related Topics

- [CSRF Tokens](../core/csrf-tokens.md)
- [Form Controls](form-controls.md)
- [nchan/WebSocket Integration](../core/nchan-websocket.md)
