# Zsh Shell Utils – Function Reference

This document describes each function provided in `zsh-utils-functions.zsh`.

---

## Function List (Alphabetical)

### cbn

**Copy current branch name to clipboard.**

Copies the name of the currently checked-out Git branch to your clipboard and prints it.

---

### c

**Clear the terminal.**

Runs the `clear` command.

---

### dev

**Checkout the `develop` branch.**

Runs `git checkout develop`.

---

### editAliases

**Open your Zsh configuration in VS Code.**

Opens `~/.zshrc` in Visual Studio Code for editing.

---

### explorer

**Open Finder in the current directory.**

Opens the current directory in Finder (macOS only).

---

### g-

**Checkout the previous Git branch.**

Runs `git checkout -` to switch to the last checked-out branch.

---

### gch

**Interactively checkout a branch (local or remote) using [fuzzy search](#fuzzy-search).**

- Shows a list of all unique branch names (local and remote) using [fuzzy search](#fuzzy-search).
- Optional argument: prefills the fuzzy-search query (e.g. `gch feat`). If it matches a single branch, it's auto-selected.
- If the branch exists locally, checks it out.
- If not, checks remotes:
  - If only one remote has the branch, creates a local branch from it.
  - If multiple remotes have the branch, lets you pick the remote.

---

### gclone

**Interactively select a GitHub org and repo to clone into `$REPOSITORIES_FOLDER`.**

- Lists your GitHub orgs (via `gh`) and lets you pick one using [fuzzy search](#fuzzy-search).
- Lists repos in the selected org (up to 200) and lets you pick one using [fuzzy search](#fuzzy-search).
- Clones the selected repo into `$REPOSITORIES_FOLDER` and `cd`s into it.
- Requires `gh` (authenticated) and `fzf`.

---

### gpick

**Interactively cherry-pick a commit from any branch using [fuzzy search](#fuzzy-search).**

- Lets you select a branch, then a commit from that branch, both using [fuzzy search](#fuzzy-search).
- Cherry-picks the selected commit onto your current branch.

---

### greba

**Interactively rebase from a selected branch or commit using [fuzzy search](#fuzzy-search).**

- Lets you choose to rebase from a branch or a commit.
- If branch: select branch with [fuzzy search](#fuzzy-search).
- If commit: select commit from current branch with [fuzzy search](#fuzzy-search).
- Runs `git rebase` from the selected point.

---

### gwt

**Interactively create a git worktree with naming convention `repoName__branchName`.**

- Shows a list of all unique branch names (local and remote) using [fuzzy search](#fuzzy-search).
- Optional argument: prefills the fuzzy-search query; a single match is auto-selected.
- Creates a worktree in the parent directory with name format: `${repoName}__${branchName}`
- If the worktree already exists:
  - If empty: removes and creates a fresh worktree.
  - If has content: navigates to the existing worktree (with warning).
- If the branch exists locally, creates worktree from it.
- If not, checks remotes:
  - If only one remote has the branch, creates worktree from it.
  - If multiple remotes have the branch, lets you pick the remote.
- Automatically navigates to the new worktree.

---

### gwt-delete

**Interactively delete a git worktree and its directory.**

- Shows a list of all worktrees (excluding main repo) using [fuzzy search](#fuzzy-search).
- Removes the worktree using `git worktree remove`.
- If the directory still exists after removal, deletes it.
- If files remain after deletion (permission issues, etc.), warns user to manually review and delete.
- Prevents deletion if you're currently inside the worktree (requires `cd` out first).

---

### history-widget

**Interactively select a command from your shell history using [fuzzy search](#fuzzy-search).**

- Shows your shell history (without duplicates or line numbers) in [fuzzy search](#fuzzy-search).
- The selected command is inserted into your prompt.

---

### iterm

**Open iTerm in the current directory.**

Opens iTerm (macOS only).

---

### repo

**Interactively select and cd into a repository.**

- Shows all directories in `$REPOSITORIES_FOLDER` using [fuzzy search](#fuzzy-search).
- Changes directory to the selected repository.

---

### seeprs

**Select a GitHub repo and open its pull requests page in the browser.**

- Lists every repo you own or can access through your GitHub orgs, using [fuzzy search](#fuzzy-search).
- When run inside a GitHub repo, that repo is preselected as the search query, so pressing enter accepts it.
- Opens the pull requests page of the selected repo with `gh pr list --web`.
- Accepts an optional query to prefill the fuzzy search: `seeprs db-writer`.
- The repo list is cached in `${XDG_CACHE_HOME:-$HOME/.cache}/shell-utils/repos.txt` and rebuilt every 24 hours. Run `seeprs --refresh` to rebuild it immediately.
- Requires `gh` (authenticated) and `fzf`.

---

### selbra

**Interactively select a branch and copy its name to clipboard.**

- Shows a list of all unique branch names (local and remote) using [fuzzy search](#fuzzy-search).
- Optional argument: prefills the fuzzy-search query; a single match is auto-selected.
- Copies the selected branch name to your clipboard and prints it.

---

### selco

**Interactively select a commit and copy its hash to clipboard.**

- Shows a list of commits (hash and message) from the current branch using [fuzzy search](#fuzzy-search).
- Copies the selected commit hash to your clipboard and prints it.

---

# Aliases

See the main README for a list of useful aliases.

---

# See Also

- [Main README](../README.md)

---

## Fuzzy Search

Fuzzy search is a method that allows you to find and select items from a list by typing approximate or partial matches, making the selection process quick and interactive.
