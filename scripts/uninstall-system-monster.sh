#!/bin/bash

# Monster Code System-Wide Uninstaller
# Removes system-wide installations that require admin privileges

echo "🔧 Monster Code System-Wide Uninstaller"
echo "======================================="
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

# Remove system-wide installations
echo "🗑️  Removing system-wide Monster installations..."

if [[ -f "/usr/local/bin/monster" ]]; then
    echo "🗑️  Removing: /usr/local/bin/monster"
    rm -f "/usr/local/bin/monster"
fi

if [[ -L "/usr/local/bin/monster" ]]; then
    echo "🗑️  Removing: /usr/local/bin/monster (symlink)"
    rm -f "/usr/local/bin/monster"
fi

if [[ -d "/Applications/MonsterCode.app" ]]; then
    echo "🗑️  Removing: /Applications/MonsterCode.app"
    rm -rf "/Applications/MonsterCode.app"
fi

# Remove system-wide configuration
if [[ -f "/usr/local/etc/monster-env.sh" ]]; then
    echo "🗑️  Removing: /usr/local/etc/monster-env.sh"
    rm -f "/usr/local/etc/monster-env.sh"
fi

echo ""
echo "✅ System-wide Monster installations removed!"
echo ""
echo "💡 All Monster Code installations have been completely removed."
echo "   You can now install a fresh copy if needed."