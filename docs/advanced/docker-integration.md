---
layout: default
title: Docker Integration
parent: Advanced Topics
nav_order: 1
---

# Docker Integration

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/unraid-plugin-docs/blob/main/CONTRIBUTING.md)

## Overview

Plugins can interact with Docker to manage containers, inspect images, and monitor container status. Unraid runs Docker natively, making container integration a powerful option for plugins.

## Docker API Access

### Via Command Line

```php
<?
// List running containers
exec("docker ps --format '{{.Names}}'", $containers);

// Get container info as JSON
$containerName = "mycontainer";
exec("docker inspect $containerName", $output);
$info = json_decode(implode('', $output), true);
?>
```

### Via Docker Socket

```php
<?
// Direct socket communication (advanced)
$socket = "/var/run/docker.sock";

// Using curl with Unix socket
$cmd = "curl -s --unix-socket $socket http://localhost/containers/json";
exec($cmd, $output);
$containers = json_decode(implode('', $output), true);
?>
```

## Common Operations

### List Containers

```php
<?
// Get all containers (including stopped)
exec("docker ps -a --format '{{json .}}'", $output);

$containers = [];
foreach ($output as $line) {
    $containers[] = json_decode($line, true);
}
?>
```

### Start/Stop Containers

```php
<?
function startContainer($name) {
    exec("docker start " . escapeshellarg($name), $output, $retval);
    return $retval === 0;
}

function stopContainer($name) {
    exec("docker stop " . escapeshellarg($name), $output, $retval);
    return $retval === 0;
}

function restartContainer($name) {
    exec("docker restart " . escapeshellarg($name), $output, $retval);
    return $retval === 0;
}
?>
```

### Get Container Logs

```php
<?
function getContainerLogs($name, $lines = 100) {
    exec("docker logs --tail " . intval($lines) . " " . escapeshellarg($name) . " 2>&1", $output);
    return implode("\n", $output);
}
?>
```

### Check Container Status

```php
<?
function isContainerRunning($name) {
    exec("docker inspect -f '{{.State.Running}}' " . escapeshellarg($name) . " 2>/dev/null", $output);
    return isset($output[0]) && $output[0] === 'true';
}
?>
```

## Container Stats

```php
<?
// Get resource usage
exec("docker stats --no-stream --format '{{json .}}' mycontainer", $output);
$stats = json_decode($output[0], true);

// $stats contains: CPUPerc, MemUsage, NetIO, BlockIO, etc.
?>
```

## Working with Images

```php
<?
// List images
exec("docker images --format '{{json .}}'", $output);

// Pull an image
exec("docker pull myimage:latest 2>&1", $output, $retval);

// Remove an image
exec("docker rmi myimage:latest 2>&1", $output, $retval);
?>
```

## Unraid Docker Integration

### Reading Docker Configuration

TODO: Document Unraid-specific Docker config locations

```
/boot/config/docker.cfg          # Docker settings
/var/lib/docker/                  # Docker data (if on array)
/boot/config/plugins/dockerMan/   # Docker templates
```

### Docker Templates

TODO: Document interacting with Docker templates

## Event Monitoring

```bash
# Monitor Docker events
docker events --filter 'type=container'
```

## Security Considerations

- Always sanitize container names/input
- Be cautious with privileged operations
- Consider user permissions
- Log sensitive operations

## Best Practices

- Cache container lists when appropriate
- Handle Docker service not running
- Provide meaningful error messages
- Don't block UI on long operations

## Related Topics

- [Array/Disk Access]({% link docs/advanced/array-disk-access.md %})
- [rc.d Scripts]({% link docs/core/rc-d-scripts.md %})
- [Notifications System]({% link docs/core/notifications-system.md %})

## References

- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [Docker API Reference](https://docs.docker.com/engine/api/)
