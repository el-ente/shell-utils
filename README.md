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

## Requirements

You need to have both [oh-my-zsh](https://ohmyz.sh/) and [fzf](https://github.com/junegunn/fzf) installed.

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
