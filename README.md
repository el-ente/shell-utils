# 📖 [Function Reference](doc/index.md)

# shell-utils

This is a collection of Zsh functions and aliases to make working with Git and your terminal easier, using fzf for interactive selection.

## Installation

1. **Set the `REPOSITORIES_FOLDER` variable**

   Add this line to your Zsh configuration file (for example, in your `~/.zshrc`, `~/.zprofile`, or any file sourced by your shell):

   ```zsh
   export REPOSITORIES_FOLDER="$HOME/repos"
   ```

2. **Source the functions in your Zsh config**

   Add this line to your Zsh configuration file:

   ```zsh
   source "$REPOSITORIES_FOLDER/shell-utils/zsh-utils-functions.zsh"
   ```

3. **Reload your shell configuration**

   You can restart your terminal or run:

   ```sh
   source <your-zsh-config-file>
   ```

4. **Clone this repository into that folder**

   Now that the variable is available, run:

   ```sh
   git clone git@github.com:el-ente/shell-utils.git "$REPOSITORIES_FOLDER/shell-utils"
   ```

## What else is in this repo?

- **`install.sh`** — bootstraps a Mac (Homebrew, CLI tools, GUI apps, Oh My Zsh, nvm config, configs)
- **`create-ssh-key.sh`** — generates an SSH key
- **`export-configs.sh`** — exports Maccy and Shottr configs to `configs/`
- **`CLAUDE.md`** — agent instructions for opencode/claude-code

## Requirements

You need to have [oh-my-zsh](https://ohmyz.sh/), [fzf](https://github.com/junegunn/fzf), and the [GitHub CLI (`gh`)](https://cli.github.com/) installed. `gh` must be authenticated (`gh auth login`) for the `gclone` function.

- **oh-my-zsh:**

  - See the official installation guide: [oh-my-zsh Basic Installation](https://github.com/ohmyzsh/ohmyzsh?tab=readme-ov-file#basic-installation)

- **fzf:**
  - See the official installation guide: [fzf Installation](https://github.com/junegunn/fzf?tab=readme-ov-file#installation)

Please refer to their documentation for the latest and most accurate installation steps.

## What does it include?

- Interactive Git functions (cherry-pick, rebase, checkout, copy commit hash/branch name, branch backup, and more)
- Local repository selector
- Useful Git and navigation aliases

Check the `zsh-utils-functions.zsh` file to see all available functions and how to use them.
