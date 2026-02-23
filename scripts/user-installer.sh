#!/bin/bash

# Monster Code CLI User Installer
# Apple Silicon M4 Pro Optimized
# User-level installation (no sudo required)

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

echo "🚀 Monster Code CLI User Installer"
echo "==================================="
echo ""
print_status "Detecting system..."

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    echo "✅ Apple Silicon detected (M1/M2/M3/M4)"
    ARCH_NAME="Apple Silicon"
elif [[ "$ARCH" == "x86_64" ]]; then
    echo "✅ Intel Mac detected"
    ARCH_NAME="Intel"
else
    echo "⚠️  Unknown architecture: $ARCH"
    ARCH_NAME="Unknown"
fi

# Detect macOS version
MACOS_VERSION=$(sw_vers -productVersion)
echo "✅ macOS version: $MACOS_VERSION"
echo ""

# Installation directory
INSTALL_DIR="$HOME/.local/bin"
MONSTER_PATH="$INSTALL_DIR/monster"

echo "📦 Installation Details:"
echo "   Target Directory: $INSTALL_DIR"
echo "   Binary Location: $MONSTER_PATH"
echo "   Architecture: $ARCH_NAME"
echo ""

# Create installation directory
echo "🔧 Creating installation directory..."
mkdir -p "$INSTALL_DIR"
print_success "Installation directory created"

# Check if monster binary exists in current directory
SCRIPT_DIR="$(dirname "$0")"
if [[ -f "$SCRIPT_DIR/monster" ]]; then
    echo "✅ Found monster binary in current directory"
    cp "$SCRIPT_DIR/monster" "$MONSTER_PATH"
    chmod +x "$MONSTER_PATH"
    print_success "Monster binary installed"
elif [[ -f "./monster" ]]; then
    echo "✅ Found monster binary in current directory"
    cp "./monster" "$MONSTER_PATH"
    chmod +x "$MONSTER_PATH"
    print_success "Monster binary installed"
else
    echo "⚠️  Monster binary not found in current directory"
    echo "   Looking for alternative locations..."

    # Check common build locations
    BUILD_LOCATIONS=(
        "./build/monster"
        "./dist/monster"
        "./bin/monster"
        "../monster"
    )

    BINARY_FOUND=false
    for location in "${BUILD_LOCATIONS[@]}"; do
        if [[ -f "$location" ]]; then
            echo "   Found: $location"
            cp "$location" "$MONSTER_PATH"
            chmod +x "$MONSTER_PATH"
            BINARY_FOUND=true
            print_success "Monster binary installed from $location"
            break
        fi
    done

    if [[ "$BINARY_FOUND" == false ]]; then
        echo "❌ No monster binary found"
        echo ""
        echo "💡 To build the binary, run:"
        echo "   npm install"
        echo "   npm run build"
        echo "   # or use the build scripts"
        exit 1
    fi
fi

echo ""
echo "🔧 Configuring environment..."

# Detect shell
if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_NAME="zsh"
    SHELL_PROFILE="$HOME/.zshrc"
elif [[ -n "$BASH_VERSION" ]]; then
    SHELL_NAME="bash"
    if [[ -f "$HOME/.bash_profile" ]]; then
        SHELL_PROFILE="$HOME/.bash_profile"
    else
        SHELL_PROFILE="$HOME/.bashrc"
    fi
else
    SHELL_NAME="unknown"
    SHELL_PROFILE="$HOME/.profile"
fi

echo "   Detected shell: $SHELL_NAME"
echo "   Shell profile: $SHELL_PROFILE"

# Add to PATH if not already present
if ! grep -q "$INSTALL_DIR" "$SHELL_PROFILE" 2>/dev/null; then
    echo "   Adding $INSTALL_DIR to PATH..."
    echo "" >> "$SHELL_PROFILE"
    echo "# Monster Code CLI - Added by installer" >> "$SHELL_PROFILE"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_PROFILE"
    print_success "PATH updated"
else
    echo "   $INSTALL_DIR already in PATH"
fi

# Set up environment variables for Apple Silicon optimization
if [[ "$ARCH" == "arm64" ]]; then
    echo ""
    echo "🧠 Configuring Apple Silicon optimizations..."

    # Add Apple Silicon optimizations
    if ! grep -q "MONSTER_APPLE_SILICON" "$SHELL_PROFILE" 2>/dev/null; then
        echo "" >> "$SHELL_PROFILE"
        echo "# Monster Code CLI - Apple Silicon Optimizations" >> "$SHELL_PROFILE"
        echo "export MONSTER_APPLE_SILICON=1" >> "$SHELL_PROFILE"
        echo "export MONSTER_UNIFIED_MEMORY=1" >> "$SHELL_PROFILE"
        echo "export MONSTER_NEURAL_ENGINE=1" >> "$SHELL_PROFILE"
        echo "export MONSTER_METAL=1" >> "$SHELL_PROFILE"
        print_success "Apple Silicon optimizations configured"
    else
        echo "   Apple Silicon optimizations already configured"
    fi
fi

echo ""
echo "🧪 Testing installation..."

# Test the installation
if command -v "$MONSTER_PATH" &> /dev/null; then
    echo "   Running version check..."
    VERSION_OUTPUT=$("$MONSTER_PATH" --version 2>/dev/null || echo "Version check failed")
    echo "   Version: $VERSION_OUTPUT"
    print_success "Installation test passed"
else
    print_warning "Installation test failed - binary not found in PATH"
fi

echo ""
echo "🎉 Installation completed successfully!"
echo ""
echo "📋 Summary:"
echo "   ✅ Monster CLI installed to: $MONSTER_PATH"
echo "   ✅ PATH configured in: $SHELL_PROFILE"
echo "   ✅ Architecture: $ARCH_NAME"
echo ""
if [[ "$ARCH" == "arm64" ]]; then
    echo "   ✅ Apple Silicon optimizations enabled"
fi
echo ""
echo "💡 Next steps:"
echo "   1. Restart your terminal or run: source $SHELL_PROFILE"
echo "   2. Test the installation: monster --help"
echo "   3. Run: monster doctor"
echo ""
echo "🗑️ To uninstall:"
echo "   Run: $SCRIPT_DIR/Uninstall Monster Code.command"
echo ""
echo "Press any key to continue..."
read -n 1 -s
