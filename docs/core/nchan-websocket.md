---
layout: default
title: nchan/WebSocket Integration
parent: Core Concepts
nav_order: 4
---

# nchan/WebSocket Integration

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Unraid uses [nchan](https://nchan.io/) for real-time updates via WebSockets. This allows plugins to push updates to the browser without polling.

## How nchan Works in Unraid

TODO: Document the architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Browser   │◄────│    nginx    │◄────│   Plugin    │
│ (Subscribe) │     │   (nchan)   │     │  (Publish)  │
└─────────────┘     └─────────────┘     └─────────────┘
```

## Subscribing to Channels (Client-Side)

```javascript
// Subscribe to a channel
var eventSource = new EventSource('/sub/yourplugin');

eventSource.onmessage = function(event) {
    var data = JSON.parse(event.data);
    // Handle the update
    console.log(data);
};
```

## Publishing to Channels (Server-Side)

```php
<?
// Using nchan_publish function
// TODO: Document the actual function signature and location
nchan_publish('yourplugin', json_encode([
    'status' => 'updated',
    'data' => $someData
]));
?>
```

## Common Channels

TODO: Document built-in channels plugins can subscribe to

| Channel | Description |
|---------|-------------|
| `/sub/update` | General update channel |
| `/sub/notify` | Notification updates |
| ... | ... |

## Creating Custom Channels

TODO: Document how to create and manage custom channels

## Best Practices

TODO: Document best practices for real-time updates

- Throttling updates
- Handling reconnection
- Data format conventions

## Related Topics

- [JavaScript Patterns]({% link docs/ui/javascript-patterns.md %})
- [Dashboard Tiles]({% link docs/ui/dashboard-tiles.md %})

## References

- [nchan documentation](https://nchan.io/)
