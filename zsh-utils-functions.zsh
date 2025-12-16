#!/bin/zsh

plugins=(git fzf-tab)

source $ZSH/oh-my-zsh.sh

# Check if fzf-tab is installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
    echo "fzf-tab plugin not found. Install it with:"
    echo "git clone https://github.com/Aloxaf/fzf-tab \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab"
fi

# history-widget: Select a command from shell history using fzf, filtering duplicates and removing line numbers.
function history-widget {
    # Get command history with line numbers removed, reverse order, and filter duplicates
    local selected_command=$(fc -l 1 | awk '{$1=""; print substr($0,2)}' | tail -r | awk '!seen[$0]++' | fzf --prompt="Select command: " --height=40%)
    
    if [ -z "$selected_command" ]; then
        echo "No command selected"
        return 1
    fi

    print -z "$selected_command"
}

# Create alias for the history widget
alias hg='history-widget'

# Import the Bash-compatible functions and aliases
source "$(dirname "$0")/bash-utils-functions.sh"