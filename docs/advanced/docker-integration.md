---
layout: default
title: Docker Integration
parent: Advanced Topics
nav_order: 1
---

# Docker Integration

## Overview

Plugins can interact with Docker to manage containers, inspect images, and monitor container status. Unraid runs Docker natively, making container integration a powerful option for plugins.

## Unraid Docker Labels

Unraid uses specific Docker labels to integrate containers with the WebUI. Containers with these labels appear in the Docker tab with icons, web UI links, and shell access.

### Standard Labels

| Label | Description | Example |
|-------|-------------|---------|
| `net.unraid.docker.managed` | Indicates management source | `composeman`, `dockerman` |
| `net.unraid.docker.icon` | URL to container icon | `https://example.com/icon.png` |
| `net.unraid.docker.webui` | URL to container's web interface | `http://[IP]:[PORT:8080]/` |
| `net.unraid.docker.shell` | Shell command for console access | `bash`, `sh` |

### Usage in Docker Compose

```yaml
services:
  myapp:
    image: myapp:latest
    labels:
      net.unraid.docker.managed: "composeman"
      net.unraid.docker.icon: "https://raw.githubusercontent.com/user/repo/main/icon.png"
      net.unraid.docker.webui: "http://[IP]:[PORT:8080]/"
      net.unraid.docker.shell: "bash"
```

### Reading Labels in PHP

```php
<?php
require_once("/usr/local/emhttp/plugins/dynamix.docker.manager/include/DockerClient.php");

// Define label constants
$docker_label_managed = "net.unraid.docker.managed";
$docker_label_icon = "net.unraid.docker.icon";
$docker_label_webui = "net.unraid.docker.webui";
$docker_label_shell = "net.unraid.docker.shell";

// Get container info with labels
exec("docker inspect mycontainer", $output);
$info = json_decode(implode('', $output), true);
$labels = $info[0]['Config']['Labels'] ?? [];

// Read specific labels
$icon = $labels[$docker_label_icon] ?? '';
$webui = $labels[$docker_label_webui] ?? '';
?>
```

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

Unraid stores Docker configuration in specific locations:

```
/boot/config/docker.cfg          # Docker settings
/var/lib/docker/                  # Docker data (if on array)
/boot/config/plugins/dockerMan/   # Docker templates
```

### Docker Templates

Docker templates allow Unraid to store container configurations for easy recreation.

### DockerClient.php

Unraid provides a PHP class for Docker operations:

```php
<?php
require_once("/usr/local/emhttp/plugins/dynamix.docker.manager/include/DockerClient.php");

// Use DockerUtil for image normalization
$normalizedImage = DockerUtil::ensureImageTag("nginx");
// Returns: library/nginx:latest

// Check if Docker is running
exec('/etc/rc.d/rc.docker status | grep -v "not"', $output, $retval);
$dockerRunning = ($retval === 0);
?>
```

## Docker Compose Integration

### Wrapper Script Pattern

For plugins that manage Docker Compose, use a wrapper script:

```bash
#!/bin/bash
# scripts/compose.sh
export HOME=/root

# Parse arguments
while getopts "e:c:f:p:d:" opt; do
  case $opt in
    e) envFile="--env-file $OPTARG" ;;
    c) command="$OPTARG" ;;
    f) files="$files -f $OPTARG" ;;
    p) name="$OPTARG" ;;
    d) project_dir="$OPTARG" ;;
  esac
done

case $command in
  up)
    docker compose $envFile $files -p "$name" up -d
    ;;
  down)
    docker compose $envFile $files -p "$name" down
    ;;
  pull)
    docker compose $envFile $files -p "$name" pull
    ;;
esac
```

### Stack State Detection

Determine if a compose stack is running:

```php
<?php
function getStackState($projectName) {
    exec("docker compose -p " . escapeshellarg($projectName) . " ps -q", $output);
    if (empty($output)) {
        return 'stopped';
    }
    
    // Check if any containers are running
    exec("docker ps -q --filter name=" . escapeshellarg($projectName), $running);
    return empty($running) ? 'stopped' : 'running';
}
?>
```

## Event Monitoring

```bash
# Monitor Docker events
docker events --filter 'type=container'
```

## Security Considerations

### Input Sanitization

```php
<?php
// Always escape shell arguments
$containerName = escapeshellarg($_POST['container']);
exec("docker stop $containerName");

// Validate URLs before storing
$iconUrl = $_POST['iconUrl'];
if (!filter_var($iconUrl, FILTER_VALIDATE_URL) || 
    (strpos($iconUrl, 'http://') !== 0 && strpos($iconUrl, 'https://') !== 0)) {
    echo json_encode(['result' => 'error', 'message' => 'Invalid URL']);
    exit;
}

// Whitelist allowed actions
$allowedActions = ['start', 'stop', 'restart', 'pause', 'unpause'];
if (!in_array($action, $allowedActions)) {
    echo json_encode(['result' => 'error', 'message' => 'Invalid action']);
    exit;
}
?>
```

### XSS Prevention in JavaScript

```javascript
// BAD - vulnerable to XSS
$('#error-display').html(errorMessage);

// GOOD - safe text insertion
var textNode = document.createTextNode(errorMessage);
$('#error-display').empty().append(textNode);
```

## Best Practices

### Async Loading Pattern

Don't block page load with expensive Docker commands:

```php
// compose_manager_main.php - Page loads instantly
<?php
// Note: Stack list is loaded asynchronously via AJAX
?>
<div id="compose_list">Loading...</div>
<script>
// Load data after page renders
function loadlist() {
  composeTimers.load = setTimeout(function(){
    $('div.spinner.fixed').show('slow');
  }, 500);
  
  $.get('/plugins/myplugin/php/list.php', function(data) {
    clearTimeout(composeTimers.load);
    $('#compose_list').html(data);
    $('div.spinner.fixed').hide('slow');
  });
}
$(loadlist);
</script>
```

### Namespace Your Timers

Avoid collision with Unraid's global timers:

```javascript
// BAD - may conflict with Unraid's timers
var timers = {};

// GOOD - plugin-specific namespace
var composeTimers = {};
composeTimers.load = setTimeout(...);
composeTimers.check = setInterval(...);
```

### Handle Stale Cache

Clear cached data after operations that change state:

```php
<?php
// After docker compose pull, clear the cached local SHA
$updateStatusData = DockerUtil::loadJSON($dockerManPaths['update-status']);
if (isset($updateStatusData[$image])) {
    $updateStatusData[$image]['local'] = null;  // Force re-inspection
    DockerUtil::saveJSON($dockerManPaths['update-status'], $updateStatusData);
}
?>
```

### Image Name Normalization

Docker Compose adds prefixes that must be stripped for Unraid compatibility:

```php
<?php
function normalizeImageForUpdateCheck($image) {
    // Strip docker.io/ prefix (docker compose adds this for Hub images)
    if (strpos($image, 'docker.io/') === 0) {
        $image = substr($image, 10);
    }
    // Strip @sha256: digest suffix (image pinning)
    if (($digestPos = strpos($image, '@sha256:')) !== false) {
        $image = substr($image, 0, $digestPos);
    }
    // Use Unraid's normalization for consistent format
    return DockerUtil::ensureImageTag($image);
}
?>
```

### General Guidelines

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
