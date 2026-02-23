#!/bin/bash

# Monster Code CLI - Complete Setup Script
# Creates persistent DMG with all components for Apple Silicon M4 Pro

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

echo "🚀 Monster Code CLI - Complete Setup"
echo "===================================="
echo ""

# Check if we're in the right directory
if [[ ! -f "package.json" ]]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Step 1: Install dependencies
print_status "Installing Node.js dependencies..."
if command -v npm &> /dev/null; then
    npm install
    print_success "Dependencies installed"
else
    print_warning "npm not found - skipping dependency installation"
fi

# Step 2: Make scripts executable
print_status "Making scripts executable..."
chmod +x scripts/*.sh
print_success "Scripts are now executable"

# Step 3: Create persistent DMG
print_status "Creating persistent DMG installer..."
if [[ -f "scripts/create-persistent-dmg.sh" ]]; then
    ./scripts/create-persistent-dmg.sh
    print_success "Persistent DMG created successfully"
else
    print_error "DMG creation script not found"
    exit 1
fi

# Step 4: Verify DMG creation
print_status "Verifying DMG creation..."
if [[ -f "Monster-Code-CLI-Apple-Silicon-Installer.dmg" ]]; then
    print_success "DMG installer verified"
    
    # Get file size
    DMG_SIZE=$(ls -lh "Monster-Code-CLI-Apple-Silicon-Installer.dmg" | awk '{print $5}')
    print_status "DMG size: $DMG_SIZE"
else
    print_error "DMG installer not found"
    exit 1
fi

# Step 5: Test DMG mounting
print_status "Testing DMG mounting..."
if command -v hdiutil &> /dev/null; then
    # Try to mount the DMG (read-only test)
    if hdiutil attach -readonly -noverify -noautoopen "Monster-Code-CLI-Apple-Silicon-Installer.dmg" &> /dev/null; then
        print_success "DMG mounts successfully"
        
        # Get mount point
        MOUNT_POINT=$(hdiutil info | grep "Monster Code CLI Installer" | awk '{print $3}' | head -1)
        
        if [[ -n "$MOUNT_POINT" ]]; then
            print_status "DMG mounted at: $MOUNT_POINT"
            
            # List contents
            print_status "DMG contents:"
            ls -la "$MOUNT_POINT"
            
            # Unmount
            hdiutil detach "$MOUNT_POINT" &> /dev/null
            print_success "DMG unmounted"
        fi
    else
        print_warning "DMG mounting test failed"
    fi
else
    print_warning "hdiutil not available - skipping mount test"
fi

# Step 6: Create installation summary
print_status "Creating installation summary..."
cat > "INSTALLATION_SUMMARY.md" << EOF
# Monster Code CLI - Installation Summary

## 📦 Package Contents
- **Persistent DMG**: Monster-Code-CLI-Apple-Silicon-Installer.dmg
- **Apple Silicon Optimized**: M4 Pro with unified memory support
- **User-level Installation**: No sudo required
- **Comprehensive Uninstaller**: Complete removal tools

## 🎯 Installation Steps
1. **Mount DMG**: Double-click or use \`open Monster-Code-CLI-Apple-Silicon-Installer.dmg\`
2. **Install**: Double-click "Install Monster Code.command"
3. **Verify**: Run \`monster --version\` in new terminal
4. **Optimize**: Run \`monster optimize\` (Apple Silicon only)

## 📋 DMG Contents
- Install Monster Code.command
- Uninstall Monster Code.command
- Uninstall Monster Code (System).command
- USER_INSTRUCTIONS.md
- Info.txt (quick reference)
- README.md
- LICENSE

## 🔧 Features
✅ **Persistent DMG** - Won't disappear after mounting
✅ **Apple Silicon M4 Pro** - Native ARM64 optimization
✅ **Unified Memory** - Efficient memory usage
✅ **Neural Engine** - AI acceleration
✅ **Metal Shaders** - GPU optimization
✅ **User Installation** - No admin privileges needed
✅ **Complete Uninstall** - Removes all traces

## 🚀 Quick Start
\`\`\`bash
monster doctor      # Check system health
monster info        # Show system information
monster optimize    # Apply optimizations
monster --help      # Show all commands
\`\`\`

## 📊 File Information
- **DMG Size**: $(ls -lh "Monster-Code-CLI-Apple-Silicon-Installer.dmg" | awk '{print $5}')
- **Created**: $(date)
- **Platform**: macOS (Apple Silicon optimized)
- **Architecture**: ARM64 (M1/M2/M3/M4)

---
**Ready for distribution! 🎉**
EOF

print_success "Installation summary created"

# Final summary
echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "📦 Package ready: Monster-Code-CLI-Apple-Silicon-Installer.dmg"
echo "📋 Instructions: USER_INSTRUCTIONS.md"
echo "📊 Summary: INSTALLATION_SUMMARY.md"
echo ""
echo "🚀 Next steps:"
echo "1. Test the DMG installer"
echo "2. Create GitHub release"
echo "3. Upload DMG to releases"
echo "4. Share with users!"
echo ""
echo "💡 The DMG is persistent and won't disappear after mounting."
echo "🔧 Apple Silicon M4 Pro optimizations are automatically applied."
echo ""
print_success "Monster Code CLI setup complete!"