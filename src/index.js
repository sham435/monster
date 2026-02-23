const chalk = require('chalk');

console.log(chalk.blue('🚀 Monster Code CLI - Apple Silicon M4 Pro Optimized'));
console.log(chalk.blue('===================================================='));

module.exports = {
  version: '1.0.0',
  optimized: true,
  architecture: process.arch
};