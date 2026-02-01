# Example Plugins

Learning from existing plugins is one of the best ways to understand Unraid plugin development. Here are some well-structured plugins to study.

## Recommended for Learning

### Dynamix Plugins (by @bonienl)

The gold standard for Unraid plugins. Clean, well-organized code.

| Plugin | Good For Learning |
|--------|-------------------|
| [dynamix.system.temp](https://github.com/unraid/dynamix) | Settings pages, sensor polling, nchan |
| [dynamix.system.stats](https://github.com/unraid/dynamix) | Dashboard widgets, real-time updates |

**Key patterns:**
- Clean PLG structure
- Proper package building
- Multi-language support
- Settings page templates

### Community Applications (by @Squid)

The app store plugin itself is a masterclass in PHP development.

- **Repository**: [Squidly271/community.applications](https://github.com/Squidly271/community.applications)
- **Good for**: Complex PHP, AJAX patterns, large-scale plugin architecture

**Key patterns:**
- Extensive JavaScript/AJAX
- Plugin template management
- API integration

### Compose Manager

A great example of Docker integration and modern plugin patterns.

- **Repository**: [dcflachs/compose_plugin](https://github.com/dcflachs/compose_plugin)
- **Good for**: Docker integration, event handlers, WebUI patching

**Key patterns:**
- Event scripts for Docker
- WebUI patches
- Settings with multiple options
- Build scripts for packages

### User Scripts (by @Squid)

Simple but effective plugin for running custom scripts.

- **Repository**: [Squidly271/user.scripts](https://github.com/Squidly271/user.scripts)
- **Good for**: Script management, scheduling, simple UI

### Unassigned Devices (by @dlandon)

Advanced device management plugin.

- **Repository**: [dlandon/unassigned.devices](https://github.com/dlandon/unassigned.devices)
- **Good for**: Hardware integration, mount management, complex state

## Plugin Patterns to Study

### Simple Settings Plugin

Look at `dynamix.system.temp` for:
```
├── TempSettings.page      # Settings form
├── default.cfg            # Default values
└── include/
    └── helpers.php        # Utility functions
```

### Dashboard Widget

Look at `dynamix.system.stats` for:
- Footer integration
- Real-time updates via nchan
- CSS for dashboard styling

### Docker Integration

Look at `compose.manager` for:
```
├── event/
│   ├── started            # Autostart stacks
│   └── stopping_docker    # Graceful shutdown
├── php/
│   └── exec.php           # AJAX backend
└── scripts/
    └── compose.sh         # Docker commands
```

### WebUI Patching

Look at `compose.manager/patches/` for:
- Patching Docker Manager UI
- Version-specific patches
- Patch/unpatch scripts

## Code Snippets from Real Plugins

### Reading Plugin Config

From `dynamix.system.temp`:
```php
$plugin = 'dynamix.system.temp';
$cfg = parse_plugin_cfg($plugin);
$unit = $display['unit'];  // System temperature unit
```

### AJAX Endpoint

From `compose.manager/php/exec.php`:
```php
<?php
require_once("/usr/local/emhttp/plugins/compose.manager/php/defines.php");

$action = $_POST['action'] ?? '';

switch($action) {
    case 'getStatus':
        echo getStackStatus();
        break;
    case 'startStack':
        echo startStack($_POST['name']);
        break;
    default:
        echo "Unknown action";
}
```

### Event Handler

From `compose.manager/event/started`:
```bash
#!/bin/bash
source /usr/local/emhttp/plugins/compose.manager/default.cfg
source /boot/config/plugins/compose.manager/compose.manager.cfg

for dir in $PROJECTS_FOLDER/*; do
    if [ -f "$dir/autostart" ]; then
        logger "Starting stack: ${dir##*/}"
        # Start the stack...
    fi
done
```

### Package Build Script

From `compose.manager/pkg_build.sh`:
```bash
#!/bin/bash
tmpdir=/tmp/build.$$
mkdir -p $tmpdir/usr/local/emhttp/plugins/myplugin

# Copy source files
cp -R source/myplugin/* $tmpdir/usr/local/emhttp/plugins/myplugin/

# Set permissions
chmod +x $tmpdir/usr/local/emhttp/plugins/myplugin/event/*
chmod +x $tmpdir/usr/local/emhttp/plugins/myplugin/scripts/*

# Create package
cd $tmpdir
makepkg -l y -c y /output/myplugin-package-$VERSION.txz
```

## Finding More Examples

### GitHub Search

Search for Unraid plugins:
- `unraid plugin plg` in GitHub
- `emhttp plugins` in code search
- Look at forks of popular plugins

### Installed Plugins

Your own server is a learning resource:
```bash
# List installed plugins
ls /usr/local/emhttp/plugins/

# View a plugin's files
ls -la /usr/local/emhttp/plugins/community.applications/

# Read a page file
cat /usr/local/emhttp/plugins/dynamix.system.temp/TempSettings.page
```

### Unraid Forums

- [Plugin Support](https://forums.unraid.net/forum/77-plugin-support/) - Each plugin has a support thread
- [Programming](https://forums.unraid.net/forum/57-programming/) - Developer discussions

## Tips for Studying Plugins

1. **Start with simple plugins** - Don't jump into Community Applications first
2. **Compare similar plugins** - See how different authors solve the same problem
3. **Test live** - Edit files in `/usr/local/emhttp/` to experiment
4. **Read the PLG first** - Understand what gets installed where
5. **Check the events** - See how plugins integrate with system lifecycle

## Contributing Examples

Have a well-documented plugin? Consider:
1. Adding detailed comments to your code
2. Writing a README explaining architecture
3. Submitting it to this documentation as an example

## See Also

- [Getting Started](getting-started.md) - Build your first plugin
- [Best Practices](best-practices.md) - Tips from experienced developers
- [PLG File Reference](plg-file.md) - Understanding the installer
