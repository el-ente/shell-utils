#!/bin/zsh

# Git + FZF Functions
# Interactive git functions using fzf for enhanced workflow

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

# gch: Interactively checkout a branch, handling local and remote branches with fzf.
function gch {
    # Get all branches without remote prefixes, remove duplicates
    local selected_branch=$(git branch -a --format='%(refname:short)' | sed 's|^remotes/||' | sed 's|^[^/]*/||' | sort -u | fzf --prompt="Select a branch: " --height=40%)
    
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
    # Get all branches without remote prefixes, remove duplicates
    local selected_branch=$(git branch -a --format='%(refname:short)' | sed 's|^remotes/||' | sed 's|^[^/]*/||' | sort -u | fzf --prompt="Select a branch: " --height=40%)
    
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
    # Get command history with line numbers removed and duplicates filtered
    local selected_command=$(fc -l 1 | awk '{$1=""; print substr($0,2)}' | awk '!seen[$0]++' | sort -r | fzf --prompt="Select command: " --height=40%)
    
    if [ -z "$selected_command" ]; then
        echo "No command selected"
        return 1
    fi
    
    # Insert the command into the current prompt
    print -z "$selected_command"
}

# Create alias for the history widget
alias hg='history-widget'