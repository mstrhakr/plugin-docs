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

Add Unraid labels to your compose file's `labels` section. The `[IP]` and `[PORT:xxxx]` placeholders are replaced by Unraid with the actual container IP and mapped port when displaying the WebUI link.

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

Retrieve container labels using `docker inspect` and decode the JSON output. Labels are stored in the container's Config section. Use null coalescing (`??`) to provide fallback values when labels aren't present.

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

The simplest way to interact with Docker from PHP is using the `exec()` function to run Docker CLI commands. Use the `--format` flag with Go templates to get structured output that's easy to parse.

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

For more advanced use cases, you can communicate directly with the Docker daemon via its Unix socket. This gives access to the full Docker API but requires more complex request handling.

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

Retrieve all containers (running and stopped) as JSON objects. The `--format '{{json .}}'` flag outputs one JSON object per line, which you can parse into an array.

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

Basic container lifecycle management functions. Always use `escapeshellarg()` to sanitize container names and check the return value to confirm success.

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

Fetch recent log output from a container. The `--tail` flag limits output to the most recent lines. Note that `2>&1` redirects stderr (where Docker sends some log output) to stdout.

```php
<?
function getContainerLogs($name, $lines = 100) {
    exec("docker logs --tail " . intval($lines) . " " . escapeshellarg($name) . " 2>&1", $output);
    return implode("\n", $output);
}
?>
```

### Check Container Status

Use `docker inspect` with a Go template to query specific container properties. This is more efficient than parsing full JSON output when you only need one value.

```php
<?
function isContainerRunning($name) {
    exec("docker inspect -f '{{.State.Running}}' " . escapeshellarg($name) . " 2>/dev/null", $output);
    return isset($output[0]) && $output[0] === 'true';
}
?>
```

## Container Stats

Get real-time resource usage for a container. The `--no-stream` flag returns a single snapshot instead of continuously updating output. The JSON format includes CPU percentage, memory usage, network I/O, and block I/O statistics.

```php
<?
// Get resource usage
exec("docker stats --no-stream --format '{{json .}}' mycontainer", $output);
$stats = json_decode($output[0], true);

// $stats contains: CPUPerc, MemUsage, NetIO, BlockIO, etc.
?>
```

## Container Terminal Access

Unraid® provides a built-in `openTerminal()` JavaScript function for opening container console sessions and viewing container logs in a popup window. This function handles spawning the ttyd terminal server and opening the WebSocket connection.

### The openTerminal Function

The global `openTerminal(tag, name, more)` function is defined in Unraid's core JavaScript (HeadInlineJS.php) and is available on all pages.

| Parameter | Description | Values |
|-----------|-------------|--------|
| `tag` | Terminal type | `'docker'` for containers, `'ttyd'` or `'syslog'` for system |
| `name` | Container name | Must match Docker container name exactly |
| `more` | Shell or log flag | Shell command (e.g., `'bash'`, `'sh'`) or `'.log'` for logs |

### Opening Container Console

To open an interactive shell session in a container:

```javascript
// Open bash console in a container
openTerminal('docker', 'mycontainer', 'bash');

// Open sh console (for containers without bash)
openTerminal('docker', 'mycontainer', 'sh');
```

### Viewing Container Logs

To open a live-streaming log viewer for a container, pass `'.log'` as the third parameter:

```javascript
// Open container logs in a terminal window
openTerminal('docker', 'mycontainer', '.log');
```

{: .important }
> The `'.log'` value must include the leading dot. This tells Unraid to open a log viewer instead of a shell session.

### How It Works Internally

When `openTerminal()` is called, it:

1. **Sanitizes the name**: Replaces spaces and `#` characters with underscores
2. **Opens a popup window**: Creates a sized popup for the terminal
3. **Calls OpenTerminal.php**: Makes an AJAX request to `/webGui/include/OpenTerminal.php` which spawns the ttyd process
4. **Navigates to socket URL**: After a short delay, redirects the popup to the WebSocket URL:
   - Logs: `/logterminal/{name}.log/`
   - Console: The function constructs the appropriate webterminal URL

```javascript
// Simplified view of what openTerminal does internally
function openTerminal(tag, name, more) {
  name = name.replace(/[ #]/g, "_");
  var popup = window.open('', name + (more == '.log' ? more : ''), 'width=1200,height=800');
  
  // Determine socket URL
  var socket = '/logterminal/' + name + (more == '.log' ? more : '') + '/';
  
  // Spawn ttyd process then navigate
  $.get('/webGui/include/OpenTerminal.php', {tag: tag, name: name, more: more}, function() {
    setTimeout(function() {
      popup.location = socket;
    }, 200);
  });
}
```

### Using in Plugin Context Menus

When building container context menus (like the Docker tab does), you can add Console and Logs options:

```javascript
// Adding terminal options to a context menu
var opts = [];

// Console option (only when container is running)
if (isRunning) {
  opts.push({
    text: 'Console',
    icon: 'fa-terminal',
    action: function(e) {
      e.preventDefault();
      openTerminal('docker', containerName, shell || 'bash');
    }
  });
}

// Logs option
opts.push({
  text: 'Logs',
  icon: 'fa-navicon',
  action: function(e) {
    e.preventDefault();
    openTerminal('docker', containerName, '.log');
  }
});

context.attach('#' + elementId, opts);
```

### Dashboard Tiles and openTerminal

On dashboard tiles, the global `openTerminal` function may not be available if `docker.js` isn't loaded. Check for its existence before calling, or use a fallback:

```javascript
function openContainerTerminal(name, isLogs, shell) {
  if (typeof window.openTerminal === 'function') {
    // Use Unraid's built-in function
    window.openTerminal('docker', name, isLogs ? '.log' : (shell || 'sh'));
  } else {
    // Fallback: open terminal URL directly (less reliable)
    var safeName = name.replace(/[ #]/g, '_');
    var url = isLogs
      ? '/logterminal/' + encodeURIComponent(safeName) + '.log/'
      : '/webterminal/docker/';
    window.open(url, '_blank');
  }
}
```

{: .warning }
> The fallback method of directly opening the URL may not work reliably because it doesn't call `OpenTerminal.php` to spawn the ttyd process first. Always prefer using the global `openTerminal()` function when available.

## Working with Images

Common image operations including listing, pulling, and removing. When pulling images, redirect stderr to capture progress output. Always check return values for error handling.

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

## Update Checking

Unraid's Docker Manager provides a built-in system for checking if container images have updates available. This works by comparing the local image digest (SHA256 hash) with the remote registry's current digest for the same tag.

### How Unraid Update Checking Works

1. **Local digest**: Extracted from the image's `RepoDigests` field via `docker inspect`
2. **Remote digest**: Fetched from the container registry's API (Docker Hub, GHCR, etc.)
3. **Comparison**: If digests differ, an update is available

```php
<?php
require_once("/usr/local/emhttp/plugins/dynamix.docker.manager/include/DockerClient.php");

$DockerUpdate = new DockerUpdate();
$image = "library/nginx:latest";

// Force a fresh check (fetches from registry)
$DockerUpdate->reloadUpdateStatus($image);

// Get the status: true = up-to-date, false = update available, null = unknown
$status = $DockerUpdate->getUpdateStatus($image);

if ($status === null) {
    echo "Could not check for updates";
} elseif ($status === true) {
    echo "Image is up-to-date";
} else {
    echo "Update available!";
}
?>
```

### Update Status Storage

Unraid stores update check results in a JSON file to avoid repeated registry queries:

```
/var/lib/docker/unraid-update-status.json
```

Structure:
```json
{
  "library/nginx:latest": {
    "local": "sha256:abc123...",
    "remote": "sha256:def456...",
    "status": "false"
  }
}
```

### Reading SHA Values

To display SHA digests in your UI (like showing which version will be updated):

```php
<?php
$dockerManPaths = [
    'update-status' => "/var/lib/docker/unraid-update-status.json"
];

$updateStatusData = DockerUtil::loadJSON($dockerManPaths['update-status']);
$image = "library/nginx:latest";

if (isset($updateStatusData[$image])) {
    $localSha = $updateStatusData[$image]['local'] ?? '';
    $remoteSha = $updateStatusData[$image]['remote'] ?? '';
    
    // Shorten for display (first 12 chars after "sha256:")
    if ($localSha && strpos($localSha, 'sha256:') === 0) {
        $localSha = substr($localSha, 7, 12);
    }
    if ($remoteSha && strpos($remoteSha, 'sha256:') === 0) {
        $remoteSha = substr($remoteSha, 7, 12);
    }
    
    echo "Local: $localSha → Remote: $remoteSha";
}
?>
```

### Handling Pinned Images (SHA256 Digests)

Some users pin images to specific versions using SHA256 digests in their compose files:

```yaml
services:
  redis:
    image: redis:6.2-alpine@sha256:abc123def456...
```

These pinned images should **not** be checked for updates because:
- The user explicitly wants that exact version
- Registry checks return the latest tag digest, not the pinned digest
- Comparing would always show a false "update available"

Detect and handle pinned images:

```php
<?php
/**
 * Check if an image is pinned with a SHA256 digest.
 * Returns array with image/digest info if pinned, false otherwise.
 */
function isImagePinned($image) {
    // Strip docker.io/ prefix first
    if (strpos($image, 'docker.io/') === 0) {
        $image = substr($image, 10);
    }
    
    // Check for @sha256: digest suffix
    if (($digestPos = strpos($image, '@sha256:')) !== false) {
        $baseImage = substr($image, 0, $digestPos);
        $digest = substr($image, $digestPos + 1);
        return [
            'image' => $baseImage,
            'digest' => $digest,
            'shortDigest' => substr($digest, 7, 12)  // First 12 chars
        ];
    }
    
    return false;
}

// Usage
$image = "docker.io/redis:6.2-alpine@sha256:abc123def456...";
$pinned = isImagePinned($image);

if ($pinned) {
    // Show "pinned to abc123def456" instead of checking updates
    echo "Pinned to: " . $pinned['shortDigest'];
} else {
    // Normal update check
    $DockerUpdate->reloadUpdateStatus($image);
}
?>
```

### Common Update Check Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Always shows "update available" after pull | Cached local SHA is stale | Clear `local` field before `reloadUpdateStatus()` |
| Image not found in status file | Image name format mismatch | Use `DockerUtil::ensureImageTag()` to normalize |
| Pinned image shows "not checked" | `@sha256:` suffix confuses the check | Detect pinned images and skip update check |
| Official images not matching | Missing `library/` prefix | `ensureImageTag()` adds it automatically |
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

Unraid includes a built-in PHP class that provides helper functions for Docker operations. The `DockerUtil::ensureImageTag()` function normalizes image names to match Unraid's internal format (adding `library/` prefix for official images and ensuring a tag is present).

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

A wrapper script provides a clean interface for compose operations from PHP. It handles argument parsing, environment file loading, and command execution. Setting `HOME=/root` ensures Docker can find its configuration. Using `getopts` makes the script easy to call with different parameters.

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

To determine if a compose stack is running, first check if any containers exist for the project, then verify at least one is actually running. A stack with containers that are all stopped should return 'stopped' rather than appearing active.

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

Always sanitize user input before passing to shell commands or storing in files. Use `escapeshellarg()` for command arguments, `filter_var()` for URLs, and whitelist validation for action parameters.

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

When displaying error messages or user-provided content, never insert it directly into the DOM using `.html()`. Instead, use `.text()` or `createTextNode()` to ensure special characters are escaped and cannot be interpreted as HTML or JavaScript.

```javascript
// BAD - vulnerable to XSS
$('#error-display').html(errorMessage);

// GOOD - safe text insertion
var textNode = document.createTextNode(errorMessage);
$('#error-display').empty().append(textNode);
```

## Best Practices

### Async Loading Pattern

Docker commands can take several seconds to execute, especially when listing containers or checking update status. Instead of running these commands synchronously (which blocks the page from rendering), load the page shell immediately and fetch the data via AJAX. This dramatically improves perceived performance.

The pattern below shows a delayed spinner that only appears if the AJAX request takes more than 500ms, avoiding a flash of spinner on fast responses:

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

Unraid's web UI uses a global `timers` object for its own interval/timeout management. If your plugin creates a variable with the same name, you'll overwrite Unraid's timers and break core functionality. Always use a plugin-specific namespace for your timers.

```javascript
// BAD - may conflict with Unraid's timers
var timers = {};

// GOOD - plugin-specific namespace
var composeTimers = {};
composeTimers.load = setTimeout(...);
composeTimers.check = setInterval(...);
```

### Handle Stale Cache

Unraid caches Docker image SHA hashes in `/boot/config/plugins/dynamix.docker.manager/update-status.json` for update checking. After running `docker compose pull`, the local image has changed but Unraid's cache still has the old SHA. You must clear the cached value to force Unraid to re-inspect the image and detect the update correctly.

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

Docker Compose normalizes image names differently than Unraid's Docker Manager. Compose adds `docker.io/` prefix to Docker Hub images and may include `@sha256:` digests for pinned images. To match Unraid's update-status keys, you need to strip these additions and use Unraid's `DockerUtil::ensureImageTag()` function which adds `library/` prefix to official images.

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

{: .note }
> Before normalizing, check if the image is pinned using `isImagePinned()` (see [Update Checking](#handling-pinned-images-sha256-digests)). Pinned images should display their pinned status rather than being checked for updates.
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
