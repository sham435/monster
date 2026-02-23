#!/bin/bash

# Monster Code CLI Uninstaller for macOS
# Persistent uninstaller for DMG installer
# Apple Silicon M4 Pro Optimized

echo "🗑️  Monster Code CLI Uninstaller"
echo "================================="
echo ""
echo "🔍 Searching for Monster Code installations..."
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

# Track what we find
FOUND_COUNT=0
INSTALLATIONS=()

# Check user-level installations (most common)
echo "📍 Checking user-level installations..."

# 1. User local bin
if [[ -f "$HOME/.local/bin/monster" ]]; then
    echo "   ✅ Found: $HOME/.local/bin/monster"
    INSTALLATIONS+=("$HOME/.local/bin/monster")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

if [[ -L "$HOME/.local/bin/claude" ]]; then
    echo "   ✅ Found: $HOME/.local/bin/claude (symlink)"
    INSTALLATIONS+=("$HOME/.local/bin/claude")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

# 2. Claude-specific location
if [[ -f "$HOME/.claude/bin/claude" ]]; then
    echo "   ✅ Found: $HOME/.claude/bin/claude"
    INSTALLATIONS+=("$HOME/.claude/bin/claude")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

# 3. Current directory (if running from DMG)
SCRIPT_DIR="$(dirname "$0")"
if [[ -f "$SCRIPT_DIR/monster" ]]; then
    echo "   ✅ Found: $SCRIPT_DIR/monster (DMG location)"
    INSTALLATIONS+=("$SCRIPT_DIR/monster")
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

# 4. Development locations
echo "📍 Checking development locations..."
DEV_LOCATIONS=(
    "$HOME/Applications/Monster"
    "$HOME/Development/monster"
    "$HOME/Code/monster"
    "$HOME/workspace/monster"
    "$(pwd)/monster"
)

for location in "${DEV_LOCATIONS[@]}"; do
    if [[ -d "$location" ]]; then
        echo "   ✅ Found: $location"
        INSTALLATIONS+=("$location")
        FOUND_COUNT=$((FOUND_COUNT + 1))
    fi
done

# 5. Check for system-wide installations (inform only)
echo "📍 Checking system-wide installations..."
if [[ -f "/usr/local/bin/monster" ]]; then
    echo "   ⚠️  Found: /usr/local/bin/monster (system-wide - requires admin)"
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

if [[ -L "/usr/local/bin/claude" ]]; then
    echo "   ⚠️  Found: /usr/local/bin/claude (system-wide - requires admin)"
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

if [[ -d "/Applications/MonsterCode.app" ]]; then
    echo "   ⚠️  Found: /Applications/MonsterCode.app (system-wide - requires admin)"
    FOUND_COUNT=$((FOUND_COUNT + 1))
fi

echo ""
if [[ $FOUND_COUNT -eq 0 ]]; then
    echo "✅ No Monster Code installations found!"
    echo ""
    echo "🎉 Monster Code is already completely uninstalled."
    exit 0
fi

echo "🔍 Found $FOUND_COUNT Monster Code installation(s)"
echo ""

# Show what will be removed
echo "🗑️  The following will be removed:"
echo "====================================="

USER_REMOVALS=0
SYSTEM_REMOVALS=0

for item in "${INSTALLATIONS[@]}"; do
    if [[ "$item" == /usr/local/* || "$item" == /Applications/* ]]; then
        echo "   ⚠️  $item (system-wide)"
        SYSTEM_REMOVALS=$((SYSTEM_REMOVALS + 1))
    else
        echo "   🗑️  $item (user-level)"
        USER_REMOVALS=$((USER_REMOVALS + 1))
    fi
done

echo ""

# Configuration files to remove
echo "🔍 Configuration files to clean:"
echo "================================="

CONFIG_LOCATIONS=(
    "$HOME/.config/monster"
    "$HOME/.monster"
    "$HOME/.monster-config"
    "$HOME/.local/etc/monster-env.sh"
    "$HOME/.config/monster/env.sh"
)

CONFIG_COUNT=0
for config in "${CONFIG_LOCATIONS[@]}"; do
    if [[ -f "$config" || -d "$config" ]]; then
        echo "   🗑️  $config"
        CONFIG_COUNT=$((CONFIG_COUNT + 1))
    fi
done

if [[ $CONFIG_COUNT -eq 0 ]]; then
    echo "   ✅ No configuration files found"
fi

echo ""
echo "🔍 Shell profile entries to clean:"
echo "===================================="

SHELL_PROFILES=(
    "$HOME/.zshrc"
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
    "$HOME/.profile"
)

PROFILE_COUNT=0
for profile in "${SHELL_PROFILES[@]}"; do
    if [[ -f "$profile" ]] && grep -q "monster" "$profile" 2>/dev/null; then
        echo "   🧹 $profile"
        PROFILE_COUNT=$((PROFILE_COUNT + 1))
    fi
done

if [[ $PROFILE_COUNT -eq 0 ]]; then
    echo "   ✅ No shell profile entries found"
fi

echo ""

# Ask for confirmation
read -p "❓ Do you want to uninstall Monster Code? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Uninstallation cancelled"
    exit 1
fi

echo ""
echo "🗑️  Uninstalling Monster Code..."
echo "================================"
echo ""

# Remove user-level installations
echo "🗑️  Removing user-level installations..."
for item in "${INSTALLATIONS[@]}"; do
    if [[ "$item" != /usr/local/* && "$item" != /Applications/* ]]; then
        if [[ -d "$item" ]]; then
            safe_remove_dir "$item"
        else
            safe_remove "$item"
        fi
    fi
done

# Remove configuration files
echo ""
echo "🗑️  Removing configuration files..."
for config in "${CONFIG_LOCATIONS[@]}"; do
    safe_remove_dir "$config"
done

# Clean shell profiles
echo ""
echo "🧹 Cleaning shell profiles..."
for profile in "${SHELL_PROFILES[@]}"; do
    if [[ -f "$profile" ]]; then
        if grep -q "monster" "$profile" 2>/dev/null; then
            echo "   🧹 Cleaning $profile..."
            # Create backup
            cp "$profile" "$profile.bak"
            # Remove monster-related lines
            sed -i.bak '/monster/d' "$profile" 2>/dev/null || true
            sed -i.bak '/MONSTER_/d' "$profile" 2>/dev/null || true
            echo "   ✅ Cleaned $profile (backup saved as $profile.bak)"
        fi
    fi
done

echo ""
echo "🔍 Checking for system-wide installations..."
echo "==========================================="

if [[ $SYSTEM_REMOVALS -gt 0 ]]; then
    echo "⚠️  System-wide installations found that require admin privileges:"
    echo ""
    echo "   To remove these, run this command in Terminal:"
    echo "   sudo rm -f /usr/local/bin/monster"
    echo "   sudo rm -f /usr/local/bin/claude"
    echo "   sudo rm -rf /Applications/MonsterCode.app"
    echo ""
    echo "   Or run: sudo ./Uninstall Monster Code (System).command"
fi

echo ""
echo "🔍 Final verification..."
echo "========================="

# Check what's left
REMAINING=$(find $HOME/.local/bin $HOME/.claude/bin -name "monster" -o -name "claude" 2>/dev/null | wc -l)

if [[ $REMAINING -eq 0 ]]; then
    echo "✅ All user-level Monster Code installations removed successfully!"
else
    echo "⚠️  Found $REMAINING remaining user-level installations:"
    find $HOME/.local/bin $HOME/.claude/bin -name "monster" -o -name "claude" 2>/dev/null
fi

echo ""
echo "🎉 Monster Code uninstallation complete!"
echo ""
echo "✅ Removed:"
echo "   • $USER_REMOVALS user-level installations"
echo "   • $CONFIG_COUNT configuration files"
echo "   • $PROFILE_COUNT shell profile entries"
echo ""
if [[ $SYSTEM_REMOVALS -gt 0 ]]; then
    echo "⚠️  Note: $SYSTEM_REMOVALS system-wide installations still exist"
    echo "   (requires admin privileges to remove)"
fi
echo ""
echo "💡 To reinstall Monster Code, visit:"
echo "   https://github.com/sham435/monster"
echo ""
echo "📋 You may need to restart your terminal for all changes to take effect."
echo ""
echo "Press any key to continue..."
read -n 1 -s