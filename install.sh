#!/bin/bash

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# CLI tools (formulae)
brew install \
    glow \
    bat \
    fzf \
    git \
    maven \
    nvm

# GUI apps (casks)
brew install --cask \
    claude \
    maccy \
    shottr \
    dbeaver-community \
    visual-studio-code \
    docker \
    iterm2

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# fzf-tab plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
    echo "Installing fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"
fi

# Restore app configs
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIGS_DIR="$SCRIPT_DIR/configs"

if [ -f "$CONFIGS_DIR/maccy.plist" ]; then
    echo "Restoring Maccy config..."
    defaults import org.p0deje.Maccy "$CONFIGS_DIR/maccy.plist"
fi

if [ -f "$CONFIGS_DIR/shottr.plist" ]; then
    echo "Restoring Shottr config..."
    defaults import cc.ffitch.shottr "$CONFIGS_DIR/shottr.plist"
fi

# Configure .zshrc
ZSHRC="$HOME/.zshrc"

# Ask for repositories directory
read -p "Repositories directory [$HOME/repos]: " REPOS_DIR
REPOS_DIR="${REPOS_DIR:-$HOME/repos}"
mkdir -p "$REPOS_DIR"

# Add REPOSITORIES_FOLDER export
if ! grep -q 'export REPOSITORIES_FOLDER=' "$ZSHRC" 2>/dev/null; then
    echo "export REPOSITORIES_FOLDER=\"$REPOS_DIR\"" >> "$ZSHRC"
fi

# Source zsh-utils-functions.zsh
if ! grep -q 'zsh-utils-functions.zsh' "$ZSHRC" 2>/dev/null; then
    echo "source \"$SCRIPT_DIR/zsh-utils-functions.zsh\"" >> "$ZSHRC"
fi
