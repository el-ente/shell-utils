#!/bin/zsh

plugins=(git fzf-tab)

source $ZSH/oh-my-zsh.sh

# Check if fzf-tab is installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
    echo "fzf-tab plugin not found. Install it with:"
    echo "git clone https://github.com/Aloxaf/fzf-tab \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab"
fi

# gpick: Interactively cherry-pick a commit from any branch using fzf.
function gpick {
    # Select local branch with fzf
    local selected_branch=$(git branch --format='%(refname:short)' | fzf --prompt="Select a branch: " --height=40%)
    
    if [ -z "$selected_branch" ]; then
        echo "No branch selected"
        return 1
    fi
    
    # Show commits from selected branch with format: hash message
    # Search will be only in the message column (column 2)
    local selected_commit=$(git log "$selected_branch" --pretty=format:'%h %s' | fzf --prompt="Select a commit: " --height=40% --nth=2..)
    
    if [ -z "$selected_commit" ]; then
        echo "No commit selected"
        return 1
    fi
    
    # Extract only the hash (first column)
    local commit_hash=$(echo "$selected_commit" | awk '{print $1}')
    
    # Run git cherry-pick with the hash and forward all arguments
    git cherry-pick "$commit_hash" "$@"
}

alias gpickno='gpick -n'

# greba: Interactively rebase from a selected branch or commit using fzf.
function greba {
    # Select between branch or commit
    local selection=$(echo -e "branch\ncommit" | fzf --prompt="Rebase from branch or commit?: " --height=40%)
    
    if [ -z "$selection" ]; then
        echo "Nothing selected"
        return 1
    fi
    
    local target=""
    
    if [ "$selection" = "branch" ]; then
        # Select branch
        target=$(git branch --format='%(refname:short)' | fzf --prompt="Select a branch: " --height=40%)
        
        if [ -z "$target" ]; then
            echo "No branch selected"
            return 1
        fi
    elif [ "$selection" = "commit" ]; then
        # Select commit from current branch
        local selected_commit=$(git log --pretty=format:'%h %s' | fzf --prompt="Select a commit: " --height=40% --nth=2..)
        
        if [ -z "$selected_commit" ]; then
            echo "No commit selected"
            return 1
        fi
        
        # Extract only the hash (first column)
        target=$(echo "$selected_commit" | awk '{print $1}')
    fi
    
    # Run git rebase with the target and forward all arguments
    git rebase "$target" "$@"
}

alias grebai='greba -i'

# gch: Interactively checkout a branch, handling local and remote branches with fzf.
function gch {
    # Get all branches without remote prefixes, remove duplicates, keep full branch name
    local selected_branch=$( (git branch --format='%(refname:short)'; git branch -r --format='%(refname:short)' | sed 's|^[^/]*/||') | sort -u | fzf --prompt="Select a branch: " --height=40%)
    
    if [ -z "$selected_branch" ]; then
        echo "No branch selected"
        return 1
    fi
    
    # Check if the branch exists locally
    if git show-ref --verify --quiet refs/heads/"$selected_branch"; then
        # Local branch exists, checkout directly
        git checkout "$selected_branch"
        return
    fi
    
    # Branch doesn't exist locally, search in remotes
    local remotes=($(git branch -r --format='%(refname:short)' | grep "/$selected_branch$" | sed 's|^remotes/||' | sed 's|/'"$selected_branch"'$||' | sort -u))
    
    if [ ${#remotes[@]} -eq 0 ]; then
        echo "Branch '$selected_branch' not found"
        return 1
    elif [ ${#remotes[@]} -eq 1 ]; then
        # Only one remote has this branch, checkout directly
        git checkout -b "$selected_branch" "${remotes[1]}/$selected_branch"
    else
        # Multiple remotes have this branch, ask for selection
        local selected_remote=$(printf '%s\n' "${remotes[@]}" | fzf --prompt="Branch exists in multiple remotes. Select one: " --height=40%)
        
        if [ -z "$selected_remote" ]; then
            echo "No remote selected"
            return 1
        fi
        
        git checkout -b "$selected_branch" "$selected_remote/$selected_branch"
    fi
}

# selco: Select a commit from the current branch and copy its hash to clipboard using fzf.
function selco {
    # Show commits from current branch with format: hash message
    # Search will be only in the message column (column 2)
    local selected_commit=$(git log --pretty=format:'%h %s' | fzf --prompt="Select a commit: " --height=40% --nth=2..)
    
    if [ -z "$selected_commit" ]; then
        echo "No commit selected"
        return 1
    fi
    
    # Extract only the hash (first column)
    local commit_hash=$(echo "$selected_commit" | awk '{print $1}')
    
    # Copy to clipboard
    echo "$commit_hash" | pbcopy
    
    # Return the hash
    echo "$commit_hash"
}

# selbra: Select a branch and copy its name to clipboard using fzf.
function selbra {
    # Get all branches without remote prefixes, remove duplicates, keep full branch name
    local selected_branch=$( (git branch --format='%(refname:short)'; git branch -r --format='%(refname:short)' | sed 's|^[^/]*/||') | sort -u | fzf --prompt="Select a branch: " --height=40%)
    
    if [ -z "$selected_branch" ]; then
        echo "No branch selected"
        return 1
    fi
    
    # Copy to clipboard
    echo "$selected_branch" | pbcopy
    
    # Return the branch name
    echo "$selected_branch"
}

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

# git-backup: Creates a dated backup branch of the current branch
# Usage: git-backup
# Creates: backup/YYYY-MM-DD/current-branch-name
# Example: On branch 'feature/new-ui' creates 'backup/2024-12-09/feature/new-ui'
# Note: Does not switch branches, only creates the backup reference
alias git-backup='current_branch=$(git symbolic-ref --short HEAD 2>/dev/null); if [ -n "$current_branch" ]; then date_iso=$(date +%Y-%m-%d);  backup_branch="backup/${date_iso}/${current_branch}"; if git branch "$backup_branch"; then echo "Backup branch created: $backup_branch"; else echo "Error: Could not create backup branch."; fi; else echo "Not on a Git branch."; fi'

# repo: Interactive repository selector using fzf
# Usage: repo
# Opens fzf menu with all repositories in ~/racoons/
# Navigates to selected repository directory
# Requires: fzf, $REPOSITORIES_FOLDER environment variable
repo() {
    local selected
    selected=$(ls -d "$REPOSITORIES_FOLDER"/*/ | xargs -n1 basename | fzf --prompt="Select repo: ")
    if [ -n "$selected" ]; then
        cd "$REPOSITORIES_FOLDER/$selected"
    fi
}

alias g-='git checkout -'

alias cbn='git branch --show-current | pbcopy && pbpaste'

alias c='clear'

alias iterm='open -a iTerm'

alias explorer='open -a Finder.app'

alias editAliases='code ~/.zshrc'

alias dev='git checkout develop'