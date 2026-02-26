#!/usr/bin/env bash

# =============================================================================
# GIT ALIASES
# =============================================================================

# Add, commit, checkout
alias ga="git add ."
gco() { git checkout "$@"; }
rc() { git commit -m "$@"; }

# Branches
gb() { git branch "$@"; }
alias gba="git branch -a"

# Stash
gs() { git stash "$@"; }
alias gsl="git stash list"
alias gsa="git stash push --keep-index --include-untracked"

# Push
gpu() { git push "$@"; }
alias gpa="git push && git push --tags"
alias gpt="git push --force --tags"

# Reset
gr() { git reset "$@"; }
alias grs="git reset HEAD~1"
alias grh="git reset HEAD~1 --hard"

# Log
glo() { git log --oneline "$@"; }

# Tag
gt() { git tag "$@"; }