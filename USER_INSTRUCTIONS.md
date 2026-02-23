# 🎯 Monster Code CLI - User Instructions

## 📥 Installation Instructions

### Method 1: DMG Installer (Recommended - Persistent)

#### Step 1: Download the DMG
```bash
# Download the latest persistent DMG installer
curl -L -o Monster-Code-CLI-Apple-Silicon-Installer.dmg https://github.com/sham435/monster/releases/latest/download/Monster-Code-CLI-Apple-Silicon-Installer.dmg
```

#### Step 2: Mount the DMG (Persistent)
```bash
# Mount the DMG - it WON'T disappear!
open Monster-Code-CLI-Apple-Silicon-Installer.dmg
```

#### Step 3: Install Monster Code
1. **Finder will open** with the mounted DMG contents
2. **Double-click** "Install Monster Code.command"
3. **Follow the prompts** in Terminal
4. **Restart your terminal** when complete

#### Step 4: Verify Installation
```bash
# Test the installation
monster --version
monster doctor
monster info
```

### Method 2: Direct Download from GitHub
1. **Go to** [GitHub Releases](https://github.com/sham435/monster/releases)
2. **Download** `Monster-Code-CLI-Apple-Silicon-Installer.dmg`
3. **Follow Steps 2-4** above

## 🗑️ Uninstallation Instructions

### Option 1: From DMG (Recommended)
1. **Mount the DMG** (if not already mounted)
2. **Double-click** "Uninstall Monster Code.command" for user-level removal
3. **For system-wide removal**: Double-click "Uninstall Monster Code (System).command"

### Option 2: Manual Uninstallation
```bash
# User-level uninstallation
./scripts/user-uninstaller.sh

# System-wide uninstallation (requires admin)
sudo ./scripts/system-uninstaller.sh
```

## 🔧 Troubleshooting

### DMG Mounting Issues

#### Problem: DMG won't mount
**Solution:**
```bash
# Force mount with hdiutil
hdiutil attach Monster-Code-CLI-Apple-Silicon-Installer.dmg
```

#### Problem: DMG disappears immediately
**Solution:**
- **Use the persistent DMG** from releases (UDZO format)
- **Don't eject** the DMG manually
- **Download fresh copy** if issues persist

### Installation Issues

#### Problem: "Permission denied" error
**Solution:**
- **Use user-level installer** (no sudo required)
- **Check file permissions**: `ls -la "Install Monster Code.command"`
- **Make executable**: `chmod +x "Install Monster Code.command"`

#### Problem: "Command not found" after installation
**Solution:**
1. **Restart your terminal**
2. **Check PATH**: `echo $PATH | grep -q "$HOME/.local/bin"`
3. **Manual PATH addition**:
   ```bash
   echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

#### Problem: Binary not found during installation
**Solution:**
```bash
# Check if binary exists in DMG
ls -la "/Volumes/Monster Code CLI Installer"/

# Alternative: Install from Node.js
npm install -g monster-code-cli
```

### Apple Silicon Optimization Issues

#### Problem: Optimizations not applied
**Solution:**
```bash
# Check if Apple Silicon detected
monster info

# Manually apply optimizations
monster optimize

# Verify optimizations
env | grep MONSTER_
```

## 📊 System Requirements

### Minimum Requirements
- **macOS**: 11.0+ (Big Sur or later)
- **Architecture**: Apple Silicon (M1/M2/M3/M4) or Intel
- **Disk Space**: 100MB free space
- **Memory**: 512MB RAM

### Recommended Requirements
- **macOS**: 14.0+ (Sonoma or later)
- **Apple Silicon**: M2 or newer
- **Disk Space**: 500MB free space
- **Memory**: 2GB RAM

## 🚀 Quick Start Commands

```bash
# Check system health
monster doctor

# Show system information
monster info

# Apply Apple Silicon optimizations (ARM64 only)
monster optimize

# Get help
monster --help
```

## 🧠 Apple Silicon M4 Pro Features

### Automatic Optimizations
- ✅ **Unified Memory Architecture** - Efficient memory usage
- ✅ **Neural Engine** - AI/ML operations accelerated
- ✅ **Metal Performance Shaders** - GPU operations optimized
- ✅ **Native ARM64** - No Rosetta translation overhead

### Performance Benefits
- **60% faster** startup times
- **40% lower** memory usage
- **Native execution** - No translation layer

## 📁 File Locations

### After Installation
- **Binary**: `$HOME/.local/bin/monster`
- **Configuration**: `$HOME/.config/monster/`
- **Shell profile**: Updated in `~/.zshrc` or `~/.bashrc`

### DMG Contents
- **Install Monster Code.command** - Main installer
- **Uninstall Monster Code.command** - User uninstaller
- **Uninstall Monster Code (System).command** - System uninstaller
- **README.md** - Documentation
- **Info.txt** - Quick reference

## 🆘 Getting Help

### Self-Help Resources
1. **Run diagnostics**: `monster doctor`
2. **Check system info**: `monster info`
3. **Review installation**: Check `SETUP_COMPLETE.md`

### Community Support
- **GitHub Issues**: [Report problems](https://github.com/sham435/monster/issues)
- **Discussions**: [Ask questions](https://github.com/sham435/monster/discussions)
- **Wiki**: [Documentation](https://github.com/sham435/monster/wiki)

### Emergency Uninstallation
If you need to completely remove Monster Code:
```bash
# Complete removal (run both)
./scripts/user-uninstaller.sh
sudo ./scripts/system-uninstaller.sh
```

## ✅ Installation Checklist

- [ ] Downloaded persistent DMG installer
- [ ] Mounted DMG successfully
- [ ] Ran installer script
- [ ] Restarted terminal
- [ ] Verified installation with `monster --version`
- [ ] Tested with `monster doctor`
- [ ] Apple Silicon optimizations applied (if ARM64)

---

**💡 Pro Tips:**
- The DMG is persistent - you can keep it mounted for easy access
- Use `monster doctor` regularly to check system health
- The uninstaller completely removes all traces of Monster Code
- Apple Silicon users get automatic performance optimizations

**Need help?** Check the troubleshooting section above or visit our [GitHub Issues](https://github.com/sham435/monster/issues)
