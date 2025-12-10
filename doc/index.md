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
- If the branch exists locally, checks it out.
- If not, checks remotes:
  - If only one remote has the branch, creates a local branch from it.
  - If multiple remotes have the branch, lets you pick the remote.

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

### selbra

**Interactively select a branch and copy its name to clipboard.**

- Shows a list of all unique branch names (local and remote) using [fuzzy search](#fuzzy-search).
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
