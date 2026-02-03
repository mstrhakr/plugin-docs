---
layout: default
title: Testing Plugins
parent: Advanced Topics
nav_order: 5
---

# Testing Unraid® Plugins

{: .warning }
> This page is a stub. [Help us expand it!](https://github.com/mstrhakr/plugin-docs/blob/main/CONTRIBUTING.md)

{: .note }
> Unraid® is a registered trademark of Lime Technology, Inc. This documentation is not affiliated with Lime Technology, Inc.

## Overview

Testing Unraid® plugins presents unique challenges since plugins depend on Unraid-specific globals, functions, and system state that don't exist in a standard development environment. This guide covers strategies for testing both bash scripts and PHP code.

## The Challenge

Plugins rely on:
- **Unraid globals**: `$var`, `$disks`, `$shares` arrays
- **Helper functions**: `parse_plugin_cfg()`, `autov()`, `csrf_token()`
- **System state**: Array status, Docker daemon, network configuration
- **File paths**: `/usr/local/emhttp/`, `/boot/config/plugins/`

These dependencies make traditional unit testing difficult without a running Unraid system.

## Testing Strategies

### Static Analysis (Recommended Starting Point)

Static analysis catches bugs without executing code. These tools work in any development environment:

| Tool | Purpose | Language |
|------|---------|----------|
| **PHPStan** | Type checking, bug detection | PHP |
| **PHP-CS-Fixer** | Code style/formatting | PHP |
| **ShellCheck** | Bash linting and best practices | Bash |
| **commitlint** | Commit message conventions | Any |

See the [Unraid Plugin Template](https://github.com/dkaser/unraid-plugin-template) for PHPStan/PHP-CS-Fixer configuration examples.

### Bash Script Testing with BATS

[BATS (Bash Automated Testing System)](https://github.com/bats-core/bats-core) enables unit testing for shell scripts.

```bash
#!/usr/bin/env bats
# test_compose.bats

setup() {
    # Create mock environment
    export MOCK_MODE=1
    source ./scripts/compose.sh
}

@test "parse_stack_name extracts name from path" {
    result=$(parse_stack_name "/mnt/user/appdata/mystack/docker-compose.yml")
    [ "$result" = "mystack" ]
}

@test "validate_compose_file detects missing file" {
    run validate_compose_file "/nonexistent/docker-compose.yml"
    [ "$status" -eq 1 ]
}
```

**Key techniques:**
- Extract testable functions that don't depend on system state
- Use environment variables to enable "mock mode"
- Stub external commands (`docker`, `logger`, etc.)

### PHP Testing with PHPUnit

[PHPUnit](https://phpunit.de/) is the standard PHP testing framework.

```php
<?php
// tests/UtilTest.php
use PHPUnit\Framework\TestCase;

class UtilTest extends TestCase
{
    public function testParseConfig(): void
    {
        $config = "setting1=\"value1\"\nsetting2=\"value2\"";
        $result = parse_config_string($config);
        
        $this->assertEquals('value1', $result['setting1']);
        $this->assertEquals('value2', $result['setting2']);
    }
}
```

**Mocking Unraid functions:**

```php
<?php
// tests/bootstrap.php - Mock Unraid functions

if (!function_exists('parse_plugin_cfg')) {
    function parse_plugin_cfg($plugin) {
        // Return mock config for testing
        return [
            'setting1' => 'test_value',
            'debug' => 'yes'
        ];
    }
}

if (!function_exists('autov')) {
    function autov($path) {
        return $path . '?v=test';
    }
}
```

### Integration Testing on Live Unraid

Some tests require a running Unraid system. Options include:

1. **Manual testing** - Install plugin, verify behavior
2. **SSH-based test scripts** - Run validation scripts remotely
3. **VM testing** - Unraid trial in VirtualBox/VMware
4. **Docker-based simulation** - Limited, but useful for some scenarios

```bash
# Example: Remote validation script
ssh root@unraid-server "bash -s" < ./tests/integration/test_event_handlers.sh
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Test & Lint

on: [push, pull_request]

jobs:
  shellcheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run ShellCheck
        uses: ludeeus/action-shellcheck@master
        with:
          scandir: './source'

  phpstan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: php-actions/composer@v6
      - uses: php-actions/phpstan@v3

  bats:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install BATS
        run: |
          git clone https://github.com/bats-core/bats-core.git
          cd bats-core && sudo ./install.sh /usr/local
      - name: Run tests
        run: bats tests/*.bats
```

## Testable Code Patterns

### Extract Pure Functions

Move logic that doesn't depend on Unraid into separate, testable functions:

```php
<?php
// Before: Hard to test
function get_stack_status($path) {
    global $var;
    $cfg = parse_plugin_cfg('compose.manager');
    // ... complex logic using $var and $cfg
}

// After: Testable
function calculate_status($containers, $expected_count, $config) {
    // Pure function - no globals, easy to test
    if (count($containers) === 0) return 'stopped';
    if (count($containers) < $expected_count) return 'partial';
    return 'running';
}

function get_stack_status($path) {
    global $var;
    $cfg = parse_plugin_cfg('compose.manager');
    $containers = get_containers($path);
    return calculate_status($containers, $cfg['expected'], $cfg);
}
```

### Dependency Injection

```php
<?php
// Inject dependencies instead of using globals
function process_stack($path, $config = null, $logger = null) {
    $config = $config ?? parse_plugin_cfg('compose.manager');
    $logger = $logger ?? 'logger';
    
    // Now testable with mock config and logger
}
```

## Project Structure for Testing

```
myplugin/
├── source/
│   └── usr/local/emhttp/plugins/myplugin/
│       ├── *.page
│       ├── php/
│       │   └── util.php
│       └── scripts/
│           └── main.sh
├── tests/
│   ├── bootstrap.php          # Mock Unraid functions
│   ├── unit/
│   │   ├── UtilTest.php
│   │   └── main.bats
│   └── integration/
│       └── test_on_server.sh
├── composer.json              # PHPUnit, PHPStan
├── phpstan.neon
├── phpunit.xml
└── .github/workflows/
    └── test.yml
```

## Resources

- [BATS Core](https://github.com/bats-core/bats-core) - Bash testing framework
- [PHPUnit](https://phpunit.de/) - PHP testing framework
- [PHPStan](https://phpstan.org/) - PHP static analysis
- [ShellCheck](https://www.shellcheck.net/) - Shell script analysis
- [Unraid Plugin Template](https://github.com/dkaser/unraid-plugin-template) - PHPStan/linting setup

## Related Topics

- [Debugging Techniques]({% link docs/advanced/debugging-techniques.md %})
- [Build and Packaging]({% link docs/build-and-packaging.md %})

