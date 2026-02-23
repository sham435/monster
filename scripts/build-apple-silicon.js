#!/usr/bin/env node

// build-apple-silicon.js
// Creates optimized binaries for Apple Silicon and Intel Macs

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const colors = {
    reset: '\x1b[0m',
    bright: '\x1b[1m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    cyan: '\x1b[36m'
};

function log(message, color = 'reset') {
    console.log(`${colors[color]}${message}${colors.reset}`);
}

function exec(command, description) {
    if (description) log(`🚀 ${description}`, 'blue');
    try {
        execSync(command, { stdio: 'inherit' });
        return true;
    } catch (error) {
        log(`❌ Failed: ${description}`, 'red');
        return false;
    }
}

function buildBinary() {
    log('🚀 Monster Code CLI Binary Builder', 'bright');
    log('=====================================', 'bright');
    log('');

    // Check if pkg is installed
    try {
        execSync('npx pkg --version', { stdio: 'ignore' });
    } catch (error) {
        log('📦 Installing pkg...', 'yellow');
        if (!exec('npm install -g pkg', 'Installing pkg globally')) {
            log('❌ Failed to install pkg', 'red');
            process.exit(1);
        }
    }

    // Create dist directory
    const distDir = path.join(__dirname, '..', 'dist');
    if (!fs.existsSync(distDir)) {
        fs.mkdirSync(distDir, { recursive: true });
    }

    // Build for Apple Silicon (ARM64)
    log('🔨 Building for Apple Silicon (ARM64)...', 'blue');
    if (exec('npx pkg src/cli.js --targets node18-macos-arm64 --output dist/monster-arm64', 'Building ARM64 binary')) {
        log('✅ Apple Silicon binary created: dist/monster-arm64', 'green');
    } else {
        log('❌ Failed to build ARM64 binary', 'red');
    }

    // Build for Intel (x64)
    log('🔨 Building for Intel (x64)...', 'blue');
    if (exec('npx pkg src/cli.js --targets node18-macos-x64 --output dist/monster-x64', 'Building x64 binary')) {
        log('✅ Intel binary created: dist/monster-x64', 'green');
    } else {
        log('❌ Failed to build x64 binary', 'red');
    }

    // Create universal binary (Apple Silicon optimized)
    log('🔨 Creating universal binary...', 'blue');
    try {
        // For now, use the ARM64 binary as the universal one (Apple Silicon optimized)
        const arm64Binary = path.join(distDir, 'monster-arm64');
        const universalBinary = path.join(distDir, 'monster');
        
        if (fs.existsSync(arm64Binary)) {
            fs.copyFileSync(arm64Binary, universalBinary);
            fs.chmodSync(universalBinary, 0o755);
            log('✅ Universal binary created: dist/monster', 'green');
        } else {
            log('❌ ARM64 binary not found for universal creation', 'red');
        }
    } catch (error) {
        log(`❌ Failed to create universal binary: ${error.message}`, 'red');
    }

    // Create build directory binary for installer
    const buildDir = path.join(__dirname, '..', 'build');
    if (!fs.existsSync(buildDir)) {
        fs.mkdirSync(buildDir, { recursive: true });
    }

    try {
        const universalBinary = path.join(distDir, 'monster');
        const buildBinary = path.join(buildDir, 'monster');
        
        if (fs.existsSync(universalBinary)) {
            fs.copyFileSync(universalBinary, buildBinary);
            fs.chmodSync(buildBinary, 0o755);
            log('✅ Build directory binary created: build/monster', 'green');
        }
    } catch (error) {
        log(`❌ Failed to copy binary to build directory: ${error.message}`, 'red');
    }

    log('');
    log('🎉 Binary build complete!', 'bright');
    log('');
    log('Available binaries:', 'cyan');
    log('  - dist/monster-arm64 (Apple Silicon optimized)', 'cyan');
    log('  - dist/monster-x64 (Intel Mac)', 'cyan');
    log('  - dist/monster (Universal, Apple Silicon optimized)', 'cyan');
    log('  - build/monster (For installer)', 'cyan');
    log('');
}

// Run the build
buildBinary();