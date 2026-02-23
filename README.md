# Monster Code

![](https://img.shields.io/badge/Node.js-18%2B-brightgreen?style=flat-square) [![npm]](https://www.npmjs.com/package/monster-code-ui)

[npm]: https://img.shields.io/npm/v/monster-code-ui.svg?style=flat-square

Monster Code is an agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster by executing routine tasks, explaining complex code, and handling git workflows -- all through natural language commands. Use it in your terminal, IDE, or tag @monster on Github.

**Learn more in the [official documentation](https://code.monster.ai/docs/en/overview)**.

<img src="./demo.gif" />

## Get started
> [!NOTE]
> Installation via npm is deprecated. Use one of the recommended methods below.

For more installation options, uninstall steps, and troubleshooting, see the [setup documentation](https://code.monster.ai/docs/en/setup).

1. Install Monster Code:

    **MacOS/Linux (Recommended):**
    ```bash
    curl -fsSL https://monster.ai/install.sh | bash
    ```

    **Homebrew (MacOS/Linux):**
    ```bash
    brew install --cask monster-code
    ```

    **Windows (Recommended):**
    ```powershell
    irm https://monster.ai/install.ps1 | iex
    ```

    **WinGet (Windows):**
    ```powershell
    winget install Monster.MonsterCode
    ```

    **NPM (Deprecated):**
    ```bash
    npm install -g monster-code-ui
    ```

2. Navigate to your project directory and run `monster`.

## Plugins

This repository includes several Monster Code plugins that extend functionality with custom commands and agents. See the [plugins directory](./plugins/README.md) for detailed documentation on available plugins.

## Reporting Bugs

We welcome your feedback. Use the `/bug` command to report issues directly within Monster Code, or file a [GitHub issue](https://github.com/monster/monster-code/issues).

## Connect on Discord

Join the [Monster Developers Discord](https://monster.ai/discord) to connect with other developers using Monster Code. Get help, share feedback, and discuss your projects with the community.

## Data collection, usage, and retention

When you use Monster Code, we collect feedback, which includes usage data (such as code acceptance or rejections), associated conversation data, and user feedback submitted via the `/bug` command.

### How we use your data

See our [data usage policies](https://code.monster.ai/docs/en/data-usage).

### Privacy safeguards

We have implemented several safeguards to protect your data, including limited retention periods for sensitive information, restricted access to user session data, and clear policies against using feedback for model training.

For full details, please review our [Commercial Terms of Service](https://www.monster.ai/legal/commercial-terms) and [Privacy Policy](https://www.monster.ai/legal/privacy).
