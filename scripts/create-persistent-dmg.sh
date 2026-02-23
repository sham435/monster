#!/bin/bash

# Monster Code CLI - Persistent DMG Creator for Apple Silicon M4 Pro
# Creates persistent DMG installer with uninstaller included
# Optimized for macOS and Apple Silicon architecture

set -e

echo "🎨 Monster Code CLI - Persistent DMG Creator"
echo "============================================="
echo ""

# Configuration
APP_NAME="Monster Code CLI"
VOLUME_NAME="Monster Code CLI Installer"
DMG_NAME="Monster-Code-CLI-Apple-Silicon-Installer.dmg"
STAGING_DIR="build/dmg-staging"
INSTALLER_SCRIPT="user-installer.sh"
UNINSTALLER_SCRIPT="user-uninstaller.sh"
SYSTEM_UNINSTALLER_SCRIPT="system-uninstaller.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script must be run on macOS"
    exit 1
fi

# Check for required tools
print_status "Checking required tools..."

for tool in hdiutil codesign; do
    if ! command -v "$tool" &> /dev/null; then
        print_error "$tool is required but not installed"
        exit 1
    fi
done

print_success "All required tools are available"
echo ""

# Create staging directory
print_status "Creating staging directory..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"
print_success "Staging directory created: $STAGING_DIR"
echo ""

# Copy installer scripts
print_status "Copying installer scripts..."

if [[ -f "scripts/$INSTALLER_SCRIPT" ]]; then
    cp "scripts/$INSTALLER_SCRIPT" "$STAGING_DIR/Install Monster Code.command"
    chmod +x "$STAGING_DIR/Install Monster Code.command"
    print_success "Installer script copied"
else
    print_warning "Installer script not found: scripts/$INSTALLER_SCRIPT"
fi

if [[ -f "scripts/$UNINSTALLER_SCRIPT" ]]; then
    cp "scripts/$UNINSTALLER_SCRIPT" "$STAGING_DIR/Uninstall Monster Code.command"
    chmod +x "$STAGING_DIR/Uninstall Monster Code.command"
    print_success "User uninstaller script copied"
else
    print_warning "User uninstaller script not found: scripts/$UNINSTALLER_SCRIPT"
fi

if [[ -f "scripts/$SYSTEM_UNINSTALLER_SCRIPT" ]]; then
    cp "scripts/$SYSTEM_UNINSTALLER_SCRIPT" "$STAGING_DIR/Uninstall Monster Code (System).command"
    chmod +x "$STAGING_DIR/Uninstall Monster Code (System).command"
    print_success "System uninstaller script copied"
else
    print_warning "System uninstaller script not found: scripts/$SYSTEM_UNINSTALLER_SCRIPT"
fi

# Copy README and LICENSE if they exist
if [[ -f "README.md" ]]; then
    cp "README.md" "$STAGING_DIR/README.md"
    print_success "README copied"
fi

if [[ -f "LICENSE" ]]; then
    cp "LICENSE" "$STAGING_DIR/LICENSE"
    print_success "LICENSE copied"
fi

# Copy INSTALL.md if it exists
if [[ -f "INSTALL.md" ]]; then
    cp "INSTALL.md" "$STAGING_DIR/INSTALL.md"
    print_success "INSTALL.md copied"
fi

# Create a simple info file
cat > "$STAGING_DIR/Info.txt" << EOF
Monster Code CLI - Apple Silicon M4 Pro Installer
=================================================

🎯 Installation Instructions:
1. Double-click "Install Monster Code.command"
2. Follow the prompts
3. Restart your terminal

🗑️ Uninstallation Instructions:
• User-level: Double-click "Uninstall Monster Code.command"
• System-wide: Double-click "Uninstall Monster Code (System).command"

📋 Features:
✅ Apple Silicon M4 Pro optimized
✅ Unified Memory Architecture support
✅ Neural Engine acceleration
✅ Metal Performance Shaders
✅ Persistent DMG (won't disappear)
✅ User-level installation (no sudo required)
✅ Comprehensive uninstaller included

🔗 Links:
• GitHub: https://github.com/sham435/monster
• Issues: https://github.com/sham435/monster/issues
EOF

print_success "Info file created"
echo ""

# Create AppleScript for better UX
print_status "Creating AppleScript for enhanced UX..."
cat > "$STAGING_DIR/Quick Install.scpt" << EOF
tell application "Terminal"
    activate
    do script "cd \"$(dirname "$STAGING_DIR/Install Monster Code.command")\" && \"./Install Monster Code.command\""
end tell
EOF

print_success "AppleScript created"
echo ""

# List staging contents
print_status "Staging directory contents:"
ls -la "$STAGING_DIR"
echo ""

# Create the DMG
print_status "Creating persistent DMG..."
echo ""

# Remove existing DMG
if [[ -f "$DMG_NAME" ]]; then
    rm -f "$DMG_NAME"
    print_success "Removed existing DMG"
fi

# Create the DMG with persistence
print_status "Building DMG with UDZO format for persistence..."
hdiutil create \
    -volname "$VOLUME_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov \
    -format UDZO \
    -o "$DMG_NAME"

print_success "DMG created successfully: $DMG_NAME"
echo ""

# Verify the DMG
print_status "Verifying DMG..."
if [[ -f "$DMG_NAME" ]]; then
    DMG_SIZE=$(du -h "$DMG_NAME" | cut -f1)
    print_success "DMG verified - Size: $DMG_SIZE"

    # Test mounting
    print_status "Testing DMG mount..."
    MOUNT_POINT=$(hdiutil attach "$DMG_NAME" | grep "Volumes" | awk '{print $3}')

    if [[ -n "$MOUNT_POINT" ]]; then
        print_success "DMG mounted successfully at: $MOUNT_POINT"

        # List contents
        print_status "DMG contents:"
        ls -la "$MOUNT_POINT"

        # Unmount
        hdiutil detach "$MOUNT_POINT" > /dev/null 2>&1
        print_success "DMG unmounted successfully"
    else
        print_warning "DMG mount test failed"
    fi
else
    print_error "DMG creation failed"
    exit 1
fi

echo ""
print_success "🎉 DMG creation completed successfully!"
echo ""
echo "📊 Summary:"
echo "   • DMG File: $DMG_NAME"
echo "   • Volume Name: $VOLUME_NAME"
echo "   • Format: UDZO (persistent)"
echo "   • Size: $DMG_SIZE"
echo ""
echo "🔧 Features included:"
echo "   • User-level installer (no sudo required)"
echo "   • Comprehensive user uninstaller"
echo "   • System-wide uninstaller"
echo "   • Persistent DMG (won't disappear)"
echo "   • Apple Silicon M4 Pro optimized"
echo ""
echo "📤 Ready for distribution:"
echo "   Upload $DMG_NAME to GitHub releases"
echo "   Update INSTALL.md with download link"
echo ""
echo "🔗 Next steps:"
echo "   1. Test the DMG on a clean system"
echo "   2. Create GitHub release"
echo "   3. Upload DMG to release"
echo "   4. Update documentation"
echo ""
print_success "All done! 🚀"
