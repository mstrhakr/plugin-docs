# Documentation Validation Suite

This directory contains tools to validate the accuracy of this documentation against live Unraid systems.

## Contents

| File/Directory | Purpose |
|---------------|---------|
| `doctest.plg` | Installable test plugin (auto-updated by CI/CD) |
| `plugin/` | Plugin source, build scripts, and PLG template |
| `scripts/` | Validation scripts to verify documentation claims |
| `results/` | Test results from validation runs against specific Unraid versions |

## Using the Test Plugin

### Quick Install

Install directly from the Unraid Plugin Manager or via command line:

```bash
plugin install https://raw.githubusercontent.com/mstrhakr/unraid-plugin-docs/main/validation/doctest.plg
```

The plugin will auto-update when new versions are released.

### Local Development Install

For testing changes before committing:

1. Copy the plugin source to your Unraid server:
   ```bash
   scp -r validation/plugin/source root@your-server:/tmp/doctest-build/
   ```

2. Build the TXZ on the server:
   ```bash
   ssh root@your-server
   cd /tmp/doctest-build
   mkdir -p build/usr/local/emhttp/plugins/doctest
   cp -R source/emhttp/* build/usr/local/emhttp/plugins/doctest/
   # Fix line endings (critical if developed on Windows!)
   find build -path "*/event/*" -type f -exec sed -i 's/\r$//' {} \;
   chmod 755 build/usr/local/emhttp/plugins/doctest/event/*
   cd build && tar -cJf ../doctest-2026.02.01.txz .
   ```

3. Install using the local PLG:
   ```bash
   plugin install /tmp/doctest-build/doctest-local.plg
   ```

### What It Tests

The `doctest` plugin validates:

- **Event System** - All 16 documented events are logged with timestamps
- **Page Files** - Settings page demonstrates header parsing, PHP integration
- **Configuration** - `parse_plugin_cfg()` function with default values
- **Global Arrays** - Access to `$var` (system state), `$disks` (disk info)
- **Notifications** - Test button for the notification system
- **File Persistence** - Config files in `/boot/config/plugins/` survive reboot

### Plugin UI Location

After installation, go to **Settings → Other Settings → DocTest Validation**

The page shows:
- Plugin configuration using `parse_plugin_cfg()`
- Live `$var` array values (hostname, timezone, version, etc.)
- Disk count and array status
- Event log viewer (shows last 50 events)
- Test button for notifications

### Viewing Results

After installation:
- Navigate to **Settings → DocTest Validation** in the Unraid UI
- Check `/var/log/doctest-events.log` for event logging
- Review syslog: `grep doctest /var/log/syslog`

## Running Validation Scripts

The scripts can be run directly on an Unraid server:

```bash
# Copy scripts to server
scp -r scripts/ root@your-server:/tmp/validation/

# Run all validations
ssh root@your-server "bash /tmp/validation/validate-all.sh"

# Run individual validations
ssh root@your-server "bash /tmp/validation/validate-events.sh"
ssh root@your-server "bash /tmp/validation/validate-paths.sh"
ssh root@your-server "bash /tmp/validation/validate-vars.sh"
```

## Validation Results

Results are stored in `results/` with filenames matching Unraid versions:

- `unraid-7.2.3.md` - Results from Unraid 7.2.3

### Contributing Results

If you run the validation on a different Unraid version:

1. Run `validate-all.sh` on your server
2. Save the output to `results/unraid-X.Y.Z.md`
3. Submit a PR with the new results

## Validation Status

| Component | Last Validated | Unraid Version |
|-----------|---------------|----------------|
| Event System | 2026-02-01 | 7.2.3 |
| File Paths | 2026-02-01 | 7.2.3 |
| $var Array | 2026-02-01 | 7.2.3 |
| Page Files | 2026-02-01 | 7.2.3 |
| PLG Structure | 2026-02-01 | 7.2.3 |
| PHP Functions | 2026-02-01 | 7.2.3 |

## CI/CD Pipeline

The plugin is automatically built and released via GitHub Actions.

### How Releases Work

1. **Development**: Push changes to `validation/plugin/` on main branch
   - Triggers build validation
   - Artifacts are uploaded but no release created

2. **Release**: Create and push a version tag
   ```bash
   git tag v2026.02.01
   git push origin v2026.02.01
   ```
   - Builds TXZ package with proper permissions
   - Calculates SHA256 hash
   - Generates PLG file from template
   - Creates GitHub Release with all artifacts
   - Updates `validation/doctest.plg` in main branch

3. **Auto-Update**: Users with plugin installed automatically see updates
   - Unraid checks `pluginURL` for version changes
   - Plugin Manager shows available update

### Workflow File

See [`.github/workflows/plugin-release.yml`](../.github/workflows/plugin-release.yml) for the complete workflow.

### Version Format

We use date-based versioning (`YYYY.MM.DD`) following LimeTech's convention:
- `2026.02.01` - First release on Feb 1, 2026
- `2026.02.01a` - Patch release same day (append letter)

### Build Process

The CI pipeline:

1. **Converts line endings** - Windows CRLF → Unix LF
2. **Sets permissions** - Event handlers get `chmod 755`
3. **Creates TXZ** - Slackware package with `tar -cJf`
4. **Calculates SHA256** - For integrity verification
5. **Generates PLG** - Substitutes version, URL, and hash into template

### Manual Release

If CI/CD is unavailable, release manually:

```bash
# Build locally (requires Linux/WSL with tar and xz)
cd validation/plugin
./build.sh 2026.02.01

# Or build on Unraid server
ssh root@your-server
# (follow local development steps above)

# Create GitHub release manually and upload:
# - doctest-2026.02.01.txz
# - doctest.plg (with correct SHA256)
```
