#!/bin/bash
# git-aliases.sh - Git aliases from Oh My Zsh
# To use in Git Bash: Add to ~/.bashrc or ~/.bash_profile
# source ~/git-aliases.sh

# ============================================
# HELPER FUNCTIONS
# ============================================
git_current_branch() {
    git symbolic-ref --short HEAD 2>/dev/null
}

git_main_branch() {
    if git show-ref -q --verify refs/heads/main; then
        echo "main"
    else
        echo "master"
    fi
}

git_develop_branch() {
    if git show-ref -q --verify refs/heads/develop; then
        echo "develop"
    elif git show-ref -q --verify refs/heads/dev; then
        echo "dev"
    else
        echo "development"
    fi
}

_git_log_prettily() {
    if ! [ -z $1 ]; then
        git log --pretty=$1
    fi
}

# ============================================
# CUSTOM ALIASES
# ============================================
alias cbn='git branch --show-current | clip.exe'
alias dev='git checkout develop'

# ============================================
# BASIC GIT COMMANDS
# ============================================
alias g='git'
alias g-='git checkout -'
alias ga='git add'
alias gaa='git add --all'
alias gam='git am'
alias gama='git am --abort'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gamscp='git am --show-current-patch'
alias gap='git apply'
alias gapa='git add --patch'
alias gapt='git apply --3way'
alias gau='git add --update'
alias gav='git add --verbose'

# ============================================
# BRANCH OPERATIONS
# ============================================
alias gb='git branch'
alias gbD='git branch --delete --force'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbg='LANG=C git branch -vv | grep ": gone\]"'
alias gbgD='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '\''{print $1}'\'' | xargs git branch -D'
alias gbgd='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '\''{print $1}'\'' | xargs git branch -d'
alias gbl='git blame -w'
alias gbm='git branch --move'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'

# ============================================
# BISECT
# ============================================
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsn='git bisect new'
alias gbso='git bisect old'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# ============================================
# COMMIT
# ============================================
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcB='git checkout -B'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcam='git commit --all --message'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcann!='git commit --verbose --all --date=now --no-edit --amend'
alias gcans!='git commit --verbose --all --signoff --no-edit --amend'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'
alias gcb='git checkout -b'
alias gcd='git checkout $(git_develop_branch)'
alias gcf='git config --list'
alias gcfu='git commit --fixup'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean --interactive -d'
alias gclf='git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules'
alias gcm='git checkout $(git_main_branch)'
alias gcmsg='git commit --message'
alias gcn='git commit --verbose --no-edit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcount='git shortlog --summary --numbered'

# ============================================
# CHERRY-PICK
# ============================================
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# ============================================
# GPG SIGNING
# ============================================
alias gcs='git commit --gpg-sign'
alias gcsm='git commit --signoff --message'
alias gcss='git commit --gpg-sign --signoff'
alias gcssm='git commit --gpg-sign --signoff --message'

# ============================================
# DIFF
# ============================================
alias gd='git diff'
alias gdca='git diff --cached'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'

# ============================================
# FETCH
# ============================================
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune --jobs=10'
alias gfg='git ls-files | grep'
alias gfo='git fetch origin'

# ============================================
# GUI
# ============================================
alias gg='git gui citool'
alias gga='git gui citool --amend'

# ============================================
# PULL & PUSH
# ============================================
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'

# ============================================
# HELP & IGNORE
# ============================================
alias ghh='git help'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'


# ============================================
# GITK
# ============================================
alias gk='gitk --all --branches &'
alias gke='gitk --all $(git log --walk-reflogs --pretty=%h) &'

# ============================================
# LOG
# ============================================
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat --patch'
alias glo='git log --oneline --decorate'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glp='_git_log_prettily'
alias gluc='git pull upstream $(git_current_branch)'
alias glum='git pull upstream $(git_main_branch)'

# ============================================
# MERGE
# ============================================
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmff='git merge --ff-only'
alias gmom='git merge origin/$(git_main_branch)'
alias gms='git merge --squash'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/$(git_main_branch)'

# ============================================
# PUSH
# ============================================
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpod='git push origin --delete'
alias gpr='git pull --rebase'
alias gpra='git pull --rebase --autostash'
alias gprav='git pull --rebase --autostash -v'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gprom='git pull --rebase origin $(git_main_branch)'
alias gpromi='git pull --rebase=interactive origin $(git_main_branch)'
alias gprum='git pull --rebase upstream $(git_main_branch)'
alias gprumi='git pull --rebase=interactive upstream $(git_main_branch)'
alias gprv='git pull --rebase -v'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes'
alias gpu='git push upstream'
alias gpv='git push --verbose'

# ============================================
# REMOTE
# ============================================
alias gr='git remote'
alias gra='git remote add'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'
alias grv='git remote --verbose'

# ============================================
# REBASE
# ============================================
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase --interactive'
alias grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
alias grbom='git rebase origin/$(git_main_branch)'
alias grbs='git rebase --skip'
alias grbum='git rebase upstream/$(git_main_branch)'

# ============================================
# REVERT
# ============================================
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'

# ============================================
# REFLOG & RESET
# ============================================
alias grf='git reflog'
alias grh='git reset'
alias grhh='git reset --hard'
alias grhk='git reset --keep'
alias grhs='git reset --soft'
alias gru='git reset --'

# ============================================
# RESTORE
# ============================================
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

# ============================================
# ROOT DIRECTORY
# ============================================
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# ============================================
# STATUS
# ============================================
alias gsb='git status --short --branch'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status --short'
alias gst='git status'

# ============================================
# STASH
# ============================================
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstall='git stash --all'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --patch'

# ============================================
# SUBMODULE
# ============================================
alias gsu='git submodule update'

# ============================================
# SWITCH
# ============================================
alias gsw='git switch'
alias gswc='git switch --create'
alias gswd='git switch $(git_develop_branch)'
alias gswm='git switch $(git_main_branch)'

# ============================================
# TAG
# ============================================
alias gta='git tag --annotate'
alias gtl='git tag --sort=-v:refname -n --list'
alias gts='git tag --sign'
alias gtv='git tag | sort -V'

# ============================================
# UNIGNORE & UNWIP
# ============================================
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# ============================================
# MISC
# ============================================
alias gwch='git log --patch --abbrev-commit --pretty=medium --raw'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gwipe='git reset --hard && git clean --force -df'

# ============================================
# WORKTREE
# ============================================
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# ============================================
# CUSTOM UTILITY FUNCTIONS
# ============================================

# Show git status in a prettier way
gstat() {
    echo "=========================================="
    echo "           GIT STATUS OVERVIEW            "
    echo "=========================================="
    echo
    echo "📍 Current Branch: $(git_current_branch)"
    echo "🏠 Repository: $(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null || echo 'Not in a git repo')"
    echo
    git status --short --branch
    echo
    echo "📊 Commit Stats:"
    echo "   Ahead: $(git rev-list --count @{u}..HEAD 2>/dev/null || echo '0')"
    echo "   Behind: $(git rev-list --count HEAD..@{u} 2>/dev/null || echo '0')"
}

# Show recent commits in a pretty format
grecent() {
    local count=${1:-10}
    echo "=========================================="
    echo "      RECENT COMMITS (Last $count)        "
    echo "=========================================="
    git log --oneline --decorate --graph -n $count
}

# Show all branches with last commit date
gbranches() {
    echo "=========================================="
    echo "           ALL BRANCHES                   "
    echo "=========================================="
    git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

# Clean up merged branches
gcleanup() {
    echo "🧹 Cleaning up merged branches..."
    git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d
    echo "✅ Cleanup complete!"
}

# Show git help
ghelp() {
    echo "=========================================="
    echo "           GIT ALIASES HELP               "
    echo "=========================================="
    echo
    echo "📋 BASIC COMMANDS:"
    echo "  g          - git"
    echo "  ga         - git add"
    echo "  gaa        - git add --all"
    echo "  gc         - git commit -v"
    echo "  gcmsg      - git commit -m"
    echo "  gco        - git checkout"
    echo "  gcb        - git checkout -b"
    echo "  gcm        - git checkout main/master"
    echo "  gcd        - git checkout develop"
    echo
    echo "📊 STATUS & DIFF:"
    echo "  gst        - git status"
    echo "  gss        - git status -s"
    echo "  gd         - git diff"
    echo "  gdca       - git diff --cached"
    echo
    echo "📝 LOGS:"
    echo "  glog       - git log --oneline --graph"
    echo "  gloga      - git log --oneline --graph --all"
    echo "  glol       - pretty git log with time"
    echo "  grecent    - show recent commits"
    echo
    echo "🔀 PUSH/PULL:"
    echo "  gp         - git push"
    echo "  gpf        - git push --force-with-lease"
    echo "  gl         - git pull"
    echo "  ggpush     - git push origin current_branch"
    echo "  ggpull     - git pull origin current_branch"
    echo
    echo "🌿 BRANCH:"
    echo "  gb         - git branch"
    echo "  gba        - git branch -a"
    echo "  gbd        - git branch -d"
    echo "  gbranches  - show all branches with dates"
    echo "  gcleanup   - delete merged branches"
    echo
    echo "💾 STASH:"
    echo "  gsta       - git stash push"
    echo "  gstp       - git stash pop"
    echo "  gstl       - git stash list"
    echo
    echo "🔧 CUSTOM FUNCTIONS:"
    echo "  gstat      - pretty git status"
    echo "  grecent [n] - show last n commits"
    echo "  gbranches  - show all branches"
    echo "  gcleanup   - clean merged branches"
    echo "  git-backup - create backup branch"
    echo
    echo "Use 'ghelp' to see this help again"
}

# ============================================
# INITIALIZATION MESSAGE
# ============================================
echo "✅ Git aliases loaded! Type 'ghelp' for available commands"