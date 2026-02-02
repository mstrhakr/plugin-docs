#!/bin/bash
#
# validate-paths.sh - Validate documented file paths exist
# Part of: https://github.com/mstrhakr/plugin-docs
#

echo "Validating documented file paths:"
echo ""

PASS=0
FAIL=0

check_path() {
    local path="$1"
    local description="$2"
    local type="$3"  # file, dir, or symlink
    
    case "$type" in
        file)
            if [ -f "$path" ]; then
                echo "  ✅ $path"
                echo "     $description"
                ((PASS++))
            else
                echo "  ❌ $path - NOT FOUND"
                echo "     $description"
                ((FAIL++))
            fi
            ;;
        dir)
            if [ -d "$path" ]; then
                echo "  ✅ $path"
                echo "     $description"
                ((PASS++))
            else
                echo "  ❌ $path - NOT FOUND"
                echo "     $description"
                ((FAIL++))
            fi
            ;;
        symlink)
            if [ -L "$path" ]; then
                target=$(readlink "$path")
                echo "  ✅ $path -> $target"
                echo "     $description"
                ((PASS++))
            else
                echo "  ❌ $path - NOT A SYMLINK"
                echo "     $description"
                ((FAIL++))
            fi
            ;;
    esac
}

echo "=== Persistent Directories (USB Flash) ==="
check_path "/boot/config/plugins" "Plugin configuration directory" dir
check_path "/boot/config/go" "Startup script" file
check_path "/boot/config/docker.cfg" "Docker configuration" file

echo ""
echo "=== RAM Directories ==="
check_path "/usr/local/emhttp/plugins" "Active plugin files" dir
check_path "/usr/local/emhttp/webGui" "Core Unraid UI" dir
check_path "/usr/local/emhttp/state" "State files symlink" symlink

echo ""
echo "=== State Files ==="
check_path "/var/local/emhttp/var.ini" "System variables" file
check_path "/var/local/emhttp/disks.ini" "Disk information" file
check_path "/var/local/emhttp/shares.ini" "Share information" file
check_path "/var/local/emhttp/users.ini" "User information" file
check_path "/var/local/emhttp/network.ini" "Network state" file

echo ""
echo "=== Plugin Infrastructure ==="
check_path "/var/log/plugins" "Installed plugins symlinks" dir
check_path "/tmp/plugins" "Plugin temp/update files" dir
check_path "/usr/local/sbin/emhttp_event" "Event handler script" file

echo ""
echo "=== Services ==="
check_path "/etc/rc.d" "Service scripts directory" dir
check_path "/etc/cron.d" "Cron jobs directory" dir
check_path "/var/run/docker.sock" "Docker socket" file

echo ""
echo "=== Web GUI ==="
check_path "/usr/local/emhttp/webGui/scripts/notify" "Notification script" file
check_path "/usr/local/emhttp/plugins/dynamix/include/Wrappers.php" "Wrappers (parse_plugin_cfg)" file
check_path "/usr/local/emhttp/plugins/dynamix/include/Helpers.php" "Helpers (mk_option)" file

echo ""
echo "Results: $PASS passed, $FAIL failed"
