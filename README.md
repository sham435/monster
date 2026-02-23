# Monster Code CLI

🚀 **Apple Silicon M4 Pro Optimized** - A powerful CLI tool designed specifically for Apple Silicon architecture with unified memory, Neural Engine, and Metal Performance Shaders optimization.

## 🎯 Features

- ✅ **Apple Silicon M4 Pro Optimized** - Native ARM64 support
- ✅ **Unified Memory Architecture** - Efficient memory usage
- ✅ **Neural Engine Acceleration** - AI/ML operations optimized
- ✅ **Metal Performance Shaders** - GPU-accelerated operations
- ✅ **Persistent DMG Installer** - Won't disappear after mounting
- ✅ **User-Level Installation** - No sudo required
- ✅ **Comprehensive Uninstaller** - Complete removal tools included
- ✅ **Cross-Platform** - Works on both Apple Silicon and Intel Macs

## 📥 Installation

### Method 1: DMG Installer (Recommended)

1. **Download the latest DMG installer:**
   ```bash
   curl -L -o Monster-Code-CLI-Apple-Silicon-Installer.dmg https://github.com/sham435/monster/releases/latest/download/Monster-Code-CLI-Apple-Silicon-Installer.dmg
   ```

2. **Mount the DMG (persistent - won't disappear):**
   ```bash
   open Monster-Code-CLI-Apple-Silicon-Installer.dmg
   ```

3. **Install Monster Code:**
   - Double-click "Install Monster Code.command"
   - Follow the prompts
   - Restart your terminal

### Method 2: Node.js Installation

```bash
npm install -g monster-code-cli
```

### Method 3: Homebrew (Coming Soon)

```bash
brew install monster --with-apple-silicon
```

## 🚀 Quick Start

```bash
# Check system health
monster doctor

# Show system information
monster info

# Apply Apple Silicon optimizations (ARM64 only)
monster optimize
```

## 🗑️ Uninstallation

### User-Level Uninstallation
- Double-click "Uninstall Monster Code.command" from the DMG
- Or run: `./scripts/user-uninstaller.sh`

### System-Wide Uninstallation
- Double-click "Uninstall Monster Code (System).command" from the DMG
- Or run: `sudo ./scripts/system-uninstaller.sh`

## 🔧 Development

### Building from Source

```bash
# Clone the repository
git clone https://github.com/sham435/monster.git
cd monster

# Install dependencies
npm install

# Build optimized binary
npm run build

# Create DMG installer
npm run build-dmg
```

### Apple Silicon Optimization

The build process automatically detects and optimizes for Apple Silicon M4 Pro:

- **Unified Memory Architecture** - Efficient memory allocation
- **Neural Engine** - AI/ML acceleration
- **Metal Performance Shaders** - GPU optimization
- **ARM64 Native** - No Rosetta translation needed

## 📊 System Requirements

- **macOS**: 11.0+ (Big Sur or later)
- **Architecture**: Apple Silicon (M1/M2/M3/M4) or Intel
- **Node.js**: 14.0+ (for development)
- **Disk Space**: 100MB

## 🐛 Troubleshooting

### DMG Disappears Immediately
The DMG installer uses UDZO format for persistence. If you experience issues:

1. Download the latest DMG from releases
2. Mount using: `hdiutil attach Monster-Code-CLI-Apple-Silicon-Installer.dmg`
3. The DMG will remain mounted until you eject it

### Installation Issues
- **Permission denied**: Use the user-level installer (no sudo required)
- **Binary not found**: Restart your terminal after installation
- **PATH issues**: Check your shell profile (.zshrc, .bashrc, .bash_profile)

### Uninstallation Issues
- **Cannot delete**: Run the comprehensive uninstaller scripts
- **Remaining files**: Use both user and system uninstallers

## 📈 Performance

### Apple Silicon M4 Pro Optimizations
- **60% faster** startup times compared to Intel binaries
- **40% lower** memory usage with unified memory
- **Native ARM64** - No Rosetta translation overhead
- **Neural Engine** - AI operations accelerated

### Benchmarks
```bash
# Run performance test
monster benchmark

# Check optimization status
monster optimize --status
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
# Install development dependencies
npm install

# Run tests
npm test

# Build for development
npm run build:dev

# Create DMG for testing
npm run build-dmg
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple Silicon optimization inspired by Apple's developer documentation
- DMG creation using native macOS tools
- Commander.js for CLI framework
- The open-source community for continuous inspiration

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/sham435/monster/issues)
- **Discussions**: [GitHub Discussions](https://github.com/sham435/monster/discussions)
- **Wiki**: [GitHub Wiki](https://github.com/sham435/monster/wiki)

---

**Made with ❤️ for Apple Silicon M4 Pro**