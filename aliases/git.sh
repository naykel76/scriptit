#!/usr/bin/env bash

# =============================================================================
# GIT ALIASES
# =============================================================================

# Add, commit, checkout
alias ga="git add ."
gc() { git commit -m "$@"; }
gco() { git checkout "$@"; }
gcom() { git checkout main; }

# Branches
alias gba="git branch -a"
gb() { git branch "$@"; }

# Stash
alias gsa="git stash push --keep-index --include-untracked"
alias gsl="git stash list"
gs() { git stash "$@"; }

# Push
alias gpa="git push && git push --tags"
alias gpt="git push --tags" # don't use force it can cause issues with caching
gp() { git push "$@"; }
gpufor() { git push --force; } # keep a little longer for safety

# Reset
alias grh="git reset HEAD~1 --hard"
alias grs="git reset HEAD~1"
gr() { git reset "$@"; }

# Log
glo() { git log --oneline "$@"; }

# Tag
gt() { git tag "$@"; }
gtl() { git describe --tags --abbrev=0; }

