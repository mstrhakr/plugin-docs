---
layout: default
title: JavaScript Patterns
parent: UI Development
nav_order: 2
---

# JavaScript Patterns

## Overview

Unraid's web UI relies heavily on jQuery for DOM manipulation and AJAX. This page documents common patterns for interactivity in plugins.

## Available Libraries

Unraid includes these JavaScript libraries by default:
- jQuery
- SweetAlert (swal)
- TODO: List other available libraries

## AJAX Form Submission

Use jQuery's `$.post()` method to submit forms without a full page reload. This pattern intercepts the form's submit event, serializes the form data, and sends it to your PHP handler. The response can be JSON for programmatic handling or trigger a page reload on success.

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

For simpler cases where you don't need form serialization, you can build the POST data object manually. This is useful when saving individual settings or triggering actions from buttons rather than forms. Always include the CSRF token for security.

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

The simplest form of SweetAlert takes three arguments: title, message, and type. Use this for quick notifications that don't require user input or confirmation.

```javascript
swal('Title', 'Message text', 'info');
// Types: 'success', 'error', 'warning', 'info'
```

### Confirmation Dialog

Use confirmation dialogs before destructive actions like deletion or irreversible changes. The callback receives `true` if the user confirmed, allowing you to proceed with the action only after explicit approval.

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

Input dialogs collect a single text value from the user. The callback receives `false` if cancelled, an empty string if submitted empty, or the actual input value. Use `swal.showInputError()` to display validation errors without closing the dialog.

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

Load content dynamically via AJAX to update portions of the page without a full reload. This pattern is useful for status displays, logs, or any content that changes frequently. Use `setInterval()` for automatic refresh, but remember to clear the interval when the page unloads.

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

Conditionally show or hide form sections based on user selections. This improves UX by hiding irrelevant options. The `.trigger('change')` call at the end ensures the correct visibility state is set when the page first loads, not just when the user changes the value.

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

Page files can mix PHP and JavaScript, allowing you to inject server-side values into your client-side code. Use `addslashes()` when outputting PHP strings into JavaScript to prevent quote characters from breaking your code. The CSRF token is accessed from the `$var` superglobal.

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

These are the most common jQuery event patterns you'll use in Unraid plugins. The document ready handler ensures DOM elements exist before your code runs. Use `.on()` for event binding as it's the modern jQuery approach and supports event delegation.

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

Always handle AJAX errors gracefully. Network failures, server errors, and timeouts can all occur. The `$.ajax()` method provides an `error` callback for these cases. Display user-friendly error messages rather than exposing technical details.

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

Provide visual feedback during AJAX operations so users know something is happening. A simple spinner or "Loading..." message prevents users from clicking repeatedly or thinking the UI is broken.

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

For operations with measurable progress (file uploads, batch processing), a progress bar provides better feedback than a spinner. This example includes both a visual bar and text percentage. The CSS transition creates smooth animation as the bar width changes.

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

For server-side tasks that take significant time (backup, conversion, download), use a polling pattern. Start the task and receive a task ID, then periodically query the server for progress updates. This avoids HTTP timeouts and provides real-time feedback.

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

SweetAlert provides more attractive and customizable alerts than the browser's native `alert()` function. The type parameter controls the icon displayed: success (green checkmark), error (red X), warning (yellow exclamation), or info (blue i).

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

Require explicit user confirmation before destructive operations. The red confirm button color (`#d33`) signals danger. Customize button text to clearly describe what will happen ("Yes, delete it!" is clearer than "OK").

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

Collect user input inline without navigating to a separate form. The `inputValue` option pre-fills the field with a default. Handle three cases: cancelled (false), empty string, or valid input. Use `swal.showInputError()` for inline validation without closing the dialog.

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

Enable the `html: true` option to render HTML markup in the dialog body. This allows formatted content like tables, lists, or styled text. Be cautious with user-provided content—sanitize it to prevent XSS attacks.

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

Display a modal loading indicator during async operations to prevent user interaction. Disable the confirm button and outside clicks to keep users from dismissing it prematurely. Call `swal.close()` when the operation completes.

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

When SweetAlert doesn't meet your needs (complex forms, rich content, custom layouts), build a custom modal. This pattern includes the overlay background, close button, escape key handling, and click-outside-to-close behavior that users expect from modal dialogs.

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

Unraid's `dynamix.js` provides utility functions for common operations. These handle locale-aware number formatting and file size display, ensuring consistency with the rest of the Unraid UI. Use these instead of writing your own formatting code.

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

Unraid provides a `refresh()` function for updating specific page sections without a full reload. For complete page refreshes, use the standard `location.reload()`. Pass `true` to force a cache-clearing reload when you need the latest server content.

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

### Basic Shortcuts

Add keyboard shortcuts for power users. Common conventions include Ctrl+S to save and Escape to close/cancel. Always call `e.preventDefault()` to stop the browser's default behavior (Ctrl+S normally opens a "Save Page" dialog).

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

### Namespaced Event Handlers

Unraid's web UI attaches many global event handlers. If you add handlers without namespacing, they can conflict with existing handlers or accumulate on repeated page visits (SPA-style navigation). jQuery's event namespacing (e.g., `keydown.myplugin`) lets you target specific handlers for removal and prevents conflicts with other code.

```javascript
// BAD - may conflict or accumulate handlers
$(document).on('keydown', function(e) { ... });

// GOOD - namespaced event, easy to remove
$(document).off('keydown.myplugin').on('keydown.myplugin', function(e) {
    if ($('#my-modal').hasClass('active')) {
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            saveCurrentTab();
        }
        if (e.key === 'Escape') {
            e.preventDefault();
            closeModal();
        }
    }
});

// Remove handler when done
$(document).off('keydown.myplugin');
```

### Focus Trapping for Modals

For accessibility and usability, keyboard focus should stay inside a modal dialog while it's open. Without focus trapping, pressing Tab can move focus to elements behind the modal overlay, confusing users. This pattern intercepts Tab key presses and wraps focus from the last focusable element back to the first (and vice versa with Shift+Tab).

```javascript
$(document).on('keydown.mymodal', function(e) {
    if (e.key === 'Tab') {
        var $modal = $('#my-modal');
        var $focusable = $modal.find('a, button, input, textarea, select, [tabindex]:not([tabindex="-1"])').filter(':visible:not(:disabled)');
        if ($focusable.length === 0) return;
        
        var first = $focusable[0];
        var last = $focusable[$focusable.length - 1];
        
        // Trap focus inside modal
        if (!e.shiftKey && document.activeElement === last) {
            e.preventDefault();
            first.focus();
        } else if (e.shiftKey && document.activeElement === first) {
            e.preventDefault();
            last.focus();
        }
    }
});
```

## Best Practices

### Scope Your Selectors

When your plugin adds a tab to an existing Unraid page (like adding a tab to the Docker menu), your JavaScript runs in the same context as that page's JavaScript. Unscoped selectors can accidentally target elements from the parent page, causing visual glitches or broken functionality.

Common classes like `.auto_start`, `.advanced`, `.basic`, `tr.sortable`, and `.updatecolumn` are used by multiple Unraid pages. jQuery plugins like `switchButton` should never be re-initialized on elements that are already set up.

```javascript
// BAD - Selects ALL tr.sortable rows on the page
// Docker tab uses this class too, so you'll iterate over Docker containers
$('tr.sortable').each(function() {
    var $updateCell = $(this).find('.updatecolumn');
    $updateCell.html('<i class="fa fa-refresh fa-spin"></i> checking...');
});

// GOOD - Scope to your plugin's table
$('#myplugin_table tr.sortable').each(function() {
    var $updateCell = $(this).find('.updatecolumn');
    $updateCell.html('<i class="fa fa-refresh fa-spin"></i> checking...');
});
```

{: .warning }
> The Docker tab uses unscoped selectors like `$('tr.sortable')` and `$('.updatecolumn')`. If your plugin uses these same class names, clicking "Check for Updates" on Docker will animate *your* plugin's rows too. See [Namespace Your CSS Classes](#namespace-your-css-classes) below.

For elements added to shared areas (like the tab bar), use plugin-specific class names:

```javascript
// BAD - 'advancedview' class may conflict with Docker tab's toggle
$(".tabs").append('<span class="status"><input type="checkbox" class="advancedview"></span>');
$('.advancedview').switchButton({...});

// GOOD - unique class name prevents conflicts
$(".tabs").append('<span class="status"><input type="checkbox" class="myplugin-advancedview"></span>');
$('.myplugin-advancedview').switchButton({...});
$('.myplugin-advancedview').change(function(){
    // Only toggle your plugin's elements
    $('#myplugin_table .advanced').toggle();
});
```

See [Tab Pages - Adding Tabs to Existing Pages](tab-pages.md#adding-tabs-to-existing-pages) and [Icons and Styling - Namespace Your Class Names](icons-and-styling.md#namespace-your-class-names) for more details.

### Namespace Your CSS Classes

Even with scoped selectors in your own code, Unraid's core pages use unscoped selectors that will match your elements if you use common class names. The only reliable solution is to use plugin-specific class names.

Classes to avoid (used by Docker tab with unscoped selectors):
- `sortable` - Used for drag-to-reorder rows
- `updatecolumn` - Update status column
- `ct-name` - Container name cells

```html
<!-- BAD - Docker's JavaScript will target these rows -->
<tr class="sortable" id="stack-row-1">
    <td class="ct-name">My Stack</td>
    <td class="updatecolumn">not checked</td>
</tr>

<!-- GOOD - Unique class names prevent cross-tab interference -->
<tr class="myplugin-sortable" id="stack-row-1">
    <td class="myplugin-name">My Stack</td>
    <td class="myplugin-updatecolumn">not checked</td>
</tr>
```

Update your JavaScript to match:

```javascript
// Use your namespaced classes
$('#myplugin_table tr.myplugin-sortable').each(function() {
    $(this).find('.myplugin-updatecolumn').html('checking...');
});
```

This approach ensures your plugin works correctly regardless of what selectors other tabs or Unraid core might use.

### Namespace Your Timers

Unraid's core JavaScript uses a global `timers` object to manage intervals and timeouts. If your plugin declares `var timers = {}`, you'll overwrite Unraid's object and break functionality like auto-refresh and status polling. Always use a plugin-specific name like `myPluginTimers` to avoid this collision.

```javascript
// BAD - conflicts with Unraid's global timers
var timers = {};
timers.refresh = setInterval(...);

// GOOD - plugin-specific namespace
var myPluginTimers = {};
myPluginTimers.refresh = setInterval(...);
myPluginTimers.load = setTimeout(...);

// Clean up on page unload
$(window).on('beforeunload', function() {
    clearInterval(myPluginTimers.refresh);
    clearTimeout(myPluginTimers.load);
});
```

### Async Loading for Expensive Operations

Operations like listing Docker containers or checking update status can take several seconds. If you run these synchronously during page load, the user sees a blank or frozen page. Instead, render the page shell immediately with a placeholder, then fetch expensive data via AJAX.

The delayed spinner pattern (500ms timeout) ensures quick operations don't flash a spinner unnecessarily, while slow operations show appropriate feedback:

```javascript
// Show spinner with delay to avoid flash on fast loads
var myPluginTimers = {};

function loadList() {
    myPluginTimers.load = setTimeout(function(){
        $('div.spinner.fixed').show('slow');
    }, 500);
    
    $.get('/plugins/myplugin/php/list.php', function(data) {
        clearTimeout(myPluginTimers.load);
        $('#list-container').html(data);
        initializeUI();  // Set up event handlers on new content
        $('div.spinner.fixed').hide('slow');
    }).fail(function() {
        clearTimeout(myPluginTimers.load);
        $('div.spinner.fixed').hide('slow');
        $('#list-container').html('<p style="color:red">Failed to load. Please refresh.</p>');
    });
}

$(loadList);  // Load on document ready
```

### XSS Prevention

Cross-site scripting (XSS) vulnerabilities occur when user-controlled content is inserted into the DOM as HTML. Attackers can inject `<script>` tags or event handlers. jQuery's `.html()` method interprets content as HTML, while `.text()` safely escapes special characters. When you need to display error messages, usernames, or any external data, always use safe insertion methods:

```javascript
// BAD - XSS vulnerability
$('#error-display').html(errorMessage);
$('#name').html(userName);

// GOOD - safe text insertion
$('#error-display').text(errorMessage);

// GOOD - using createTextNode for complex cases
var textNode = document.createTextNode(errorMessage);
$('#error-display').empty().append(textNode);

// GOOD - escape HTML entities if you need to insert HTML structure
function escapeHtml(text) {
    return $('<div>').text(text).html();
}
$('#container').html('<span class="error">' + escapeHtml(errorMessage) + '</span>');
```

### General Guidelines

1. **Always include CSRF token** in POST requests
2. **Use proper error handling** - show user-friendly messages
3. **Provide user feedback** - show loading states, confirmations
4. **Avoid blocking UI** during long operations - use async patterns
5. **Clean up resources** - clear intervals/timeouts, close EventSources
6. **Throttle rapid actions** - prevent double-clicks, rapid submissions
7. **Handle offline state** - graceful degradation
8. **Use consistent patterns** - match Unraid's existing UI behavior

### Preventing Double-Submit

Prevent users from accidentally submitting a form multiple times by clicking rapidly or pressing Enter repeatedly. This pattern disables the submit button after the first click and uses a data attribute to track submission state.

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

Debouncing delays execution until the user stops typing, preventing excessive API calls on every keystroke. The 300ms delay is a good balance—short enough to feel responsive, long enough to avoid firing during normal typing. Clear the previous timer on each keystroke to reset the delay.

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
