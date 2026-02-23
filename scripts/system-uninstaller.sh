#!/bin/bash

# Monster Code CLI System-Wide Uninstaller
# Removes system-wide installations that require admin privileges
# Apple Silicon M4 Pro Optimized

set -e

echo "🔧 Monster Code CLI System-Wide Uninstaller"
echo "==========================================="
echo ""

# Check if running with sudo
if [[ $EUID -ne 0 ]]; then
    echo "⚠️  This script requires admin privileges."
    echo "   Running with sudo..."
    sudo "$0" "$@"
    exit $?
fi

echo "✅ Running with admin privileges"
echo ""

# Function to safely remove files
safe_remove() {
    local file="$1"
    if [[ -f "$file" || -L "$file" ]]; then
        echo "🗑️  Removing: $file"
        rm -f "$file"
    fi
}

# Function to safely remove directories
safe_remove_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        echo "🗑️  Removing directory: $dir"
        rm -rf "$dir"
    fi
}

echo "🔍 Searching for system-wide Monster installations..."
echo ""

# Track what we find
FOUND_COUNT=0
INSTALLATIONS=()

# Check system-wide locations
echo "📍 Checking system-wide locations..."

if [[ -f "/usr/local/bin/monster" ]]; then
    echo "   ✅ Found: /usr/local/bin/monster"
    INSTALLATIONS+=("/usr/local/bin/monster")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

if [[ -L "/usr/local/bin/claude" ]]; then
    echo "   ✅ Found: /usr/local/bin/claude (symlink)"
    INSTALLATIONS+=("/usr/local/bin/claude")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

if [[ -d "/Applications/MonsterCode.app" ]]; then
    echo "   ✅ Found: /Applications/MonsterCode.app"
    INSTALLATIONS+=("/Applications/MonsterCode.app")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

# Check system-wide configuration
if [[ -f "/usr/local/etc/monster-env.sh" ]]; then
    echo "   ✅ Found: /usr/local/etc/monster-env.sh"
    INSTALLATIONS+=("/usr/local/etc/monster-env.sh")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

# Check other system locations
SYSTEM_LOCATIONS=(
    "/opt/monster"
    "/usr/local/opt/monster"
    "/usr/bin/monster"
    "/usr/bin/claude"
)

for location in "${SYSTEM_LOCATIONS[@]}"; do
    if [[ -f "$location" || -d "$location" ]]; then
        echo "   ✅ Found: $location"
        INSTALLATIONS+=("$location")
        FOUND_COUNT=$((FOUND_COUNT + 1))
    fi
done

echo ""
if [[ $FOUND_COUNT -eq 0 ]]; then
    echo "✅ No system-wide Monster installations found!"
    echo ""
    echo "🎉 All system-wide Monster Code installations are already removed."
    exit 0
fi

echo "🔍 Found $FOUND_COUNT system-wide Monster installation(s)"
echo ""

# Show what will be removed
echo "🗑️  The following will be removed:"
echo "====================================="

for item in "${INSTALLATIONS[@]}"; do
    echo "   🗑️  $item"
done

echo ""

# Ask for confirmation
echo "⚠️  This will remove system-wide Monster Code installations."
read -p "❓ Do you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ System-wide uninstallation cancelled"
    exit 1
fi

echo ""
echo "🗑️  Removing system-wide Monster Code installations..."
echo "================================================"
echo ""

# Remove installations
for item in "${INSTALLATIONS[@]}"; do
    if [[ -d "$item" ]]; then
        safe_remove_dir "$item"
    else
        safe_remove "$item"
    fi
done

echo ""
echo "🔍 Final verification..."
echo "========================="

# Check what's left
REMAINING=$(find /usr/local/bin /usr/bin /opt /Applications -name "monster" -o -name "claude" -o -name "MonsterCode.app" 2>/dev/null | wc -l)

if [[ $REMAINING -eq 0 ]]; then
    echo "✅ All system-wide Monster Code installations removed successfully!"
else
    echo "⚠️  Found $REMAINING remaining system-wide installations:"
    find /usr/local/bin /usr/bin /opt /Applications -name "monster" -o -name "claude" -o -name "MonsterCode.app" 2>/dev/null
fi

echo ""
echo "🎉 System-wide Monster Code uninstallation complete!"
echo ""
echo "✅ Removed: $FOUND_COUNT system-wide installations"
echo ""
echo "💡 To reinstall Monster Code, visit:"
echo "   https://github.com/sham435/monster"
echo ""
echo "📋 You may need to restart your terminal for all changes to take effect."