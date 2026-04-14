#!/bin/zsh

# Load oh-my-zsh first (before defining custom functions/aliases)
plugins=(git fzf-tab)
source $ZSH/oh-my-zsh.sh

# Check if fzf-tab is installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
    echo "fzf-tab plugin not found. Install it with:"
    echo "git clone https://github.com/Aloxaf/fzf-tab \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab"
fi

# Custom functions and aliases (defined AFTER oh-my-zsh to avoid being overwritten)

# Helper function: Select a branch from local and remote branches using fzf
function _select_branch {
    local selected_branch=$( (git branch --format='%(refname:short)'; git branch -r --format='%(refname:short)' | sed 's|^[^/]*/||') | sort -u | fzf --prompt="Select a branch: " --height=40%)

    if [ -z "$selected_branch" ]; then
        echo "No branch selected" >&2
        return 1
    fi

    echo "$selected_branch"
}

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
        target=$(_select_branch)

        if [ -z "$target" ]; then
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
    local selected_branch=$(_select_branch)
    if [ -z "$selected_branch" ]; then
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
    local selected_branch=$(_select_branch)
    if [ -z "$selected_branch" ]; then
        return 1
    fi
    
    # Copy to clipboard
    echo "$selected_branch" | pbcopy
    
    # Return the branch name
    echo "$selected_branch"
}

# history-widget: Select a command from shell history using fzf, filtering duplicates and removing line numbers.
# Optional parameters: pre-fill fzf search query (supports multiple words)
function history-widget {
    local query="$*"

    # Get command history with line numbers removed, sorted by frequency (most common first)
    local selected_command=$(fc -l 1 | awk '{$1=""; print substr($0,2)}' | sort | uniq -c | sort -rn | awk '{$1=""; print substr($0,2)}' | fzf --prompt="Select command: " --query="$query" --height=40%)

    if [ -z "$selected_command" ]; then
        echo "No command selected"
        return 1
    fi

    # Copy to clipboard
    echo "$selected_command" | pbcopy

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

alias cat='bat'

alias grepi='grep -i'

alias c='clear'

alias iterm='open -a iTerm'

alias explorer='open -a Finder.app'

alias editAliases='code ~/.zshrc'

# gwt: Create a git worktree with naming convention: repoName__branchName
# Remove oh-my-zsh's gwt alias to use our function instead
unalias gwt 2>/dev/null

function gwt {
    # Get repo name
    local repo_root=$(git rev-parse --show-toplevel)
    if [ -z "$repo_root" ]; then
        echo "Not in a Git repository"
        return 1
    fi

    local repo_name=$(basename "$repo_root")

    # Select branch
    local selected_branch=$(_select_branch)
    if [ -z "$selected_branch" ]; then
        return 1
    fi

    # Worktree path: ../repoName__branchName
    local worktree_name="${repo_name}__${selected_branch}"
    local worktree_path="../${worktree_name}"

    # If worktree already exists
    if [ -d "$worktree_path" ]; then
        # Check if empty
        if [ -z "$(ls -A "$worktree_path")" ]; then
            echo "Worktree dir exists but empty, removing..."
            rm -rf "$worktree_path"
        else
            # Has content, just cd
            echo "⚠️  Worktree already exists, navigating to existing directory..."
            cd "$worktree_path"
            return 0
        fi
    fi

    # Check if branch exists locally
    if git show-ref --verify --quiet refs/heads/"$selected_branch"; then
        # Local branch exists, create worktree directly
        git worktree add "$worktree_path" "$selected_branch"
    else
        # Branch doesn't exist locally, search in remotes
        local remotes=($(git branch -r --format='%(refname:short)' | grep "/$selected_branch$" | sed 's|^remotes/||' | sed 's|/'"$selected_branch"'$||' | sort -u))

        if [ ${#remotes[@]} -eq 0 ]; then
            echo "Branch '$selected_branch' not found"
            return 1
        elif [ ${#remotes[@]} -eq 1 ]; then
            # Only one remote, create worktree from remote
            git worktree add "$worktree_path" "${remotes[1]}/$selected_branch"
        else
            # Multiple remotes, ask for selection
            local selected_remote=$(printf '%s\n' "${remotes[@]}" | fzf --prompt="Branch exists in multiple remotes. Select one: " --height=40%)

            if [ -z "$selected_remote" ]; then
                echo "No remote selected"
                return 1
            fi

            git worktree add "$worktree_path" "$selected_remote/$selected_branch"
        fi
    fi

    # Navigate to worktree
    cd "$worktree_path"
}

# gwt-delete: Interactively delete a git worktree and its directory
function gwt-delete {
    # Check if inside a worktree (not main repo)
    local current_dir=$(pwd)
    local main_repo=$(git rev-parse --show-toplevel)

    if [ "$current_dir" != "$main_repo" ] && git worktree list --porcelain | grep -q "^$(echo "$current_dir" | sed 's/[[\.*^$/]/\\&/g')"; then
        echo "⚠️  You're inside a worktree. Please cd out before deleting it."
        return 1
    fi

    # Navigate to main repo
    cd "$main_repo" || return 1

    # List all worktrees (exclude main repo)
    local worktree_list=$(git worktree list | awk 'NR>1 {print $1}')

    if [ -z "$worktree_list" ]; then
        echo "No worktrees found"
        return 1
    fi

    # Select worktree by basename
    local selected_basename=$(echo "$worktree_list" | xargs -n1 basename | fzf --prompt="Select worktree to delete: " --height=40%)

    if [ -z "$selected_basename" ]; then
        echo "No worktree selected"
        return 1
    fi

    # Get full path from basename
    local selected=$(echo "$worktree_list" | grep "$selected_basename$" | head -1)

    # Remove via git
    git worktree remove "$selected" 2>/dev/null

    # Remove directory if still exists
    if [ -d "$selected" ]; then
        rm -rf "$selected"

        # Check if fully removed
        if [ -d "$selected" ]; then
            echo "⚠️  Files remaining in: $selected"
            echo "Review and delete manually"
            return 1
        fi
    fi

    echo "✓ Deleted: $selected"
}

alias dev='git checkout develop'

# clone: Git clone into REPOSITORIES_FOLDER and cd into it
# Usage: clone <repo-url> [custom-name]
function clone {
    local repo_url="$1"
    local repo_name="${2:-$(basename "$repo_url" .git)}"
    git clone "$repo_url" "$REPOSITORIES_FOLDER/$repo_name" && cd "$REPOSITORIES_FOLDER/$repo_name"
}