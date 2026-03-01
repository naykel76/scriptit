#!/usr/bin/env bash

# =============================================================================
# LARAVEL / LIVEWIRE ALIASES
# =============================================================================

# composer clear-cache
# composer update naykel/gotime naykel/devit

# Base commands
alias pa="php artisan"
alias pabu="php artisan boost:update"
alias pint="./vendor/bin/pint"

# Database
alias pads="php artisan db:seed"
alias pam="php artisan migrate"
alias pamf="php artisan migrate:fresh"
alias pamfs="php artisan migrate:fresh --seed"

# Livewire
lc() { php artisan livewire:make "$@"; }
lcon() { php artisan livewire:convert "$@"; }

lca() { php artisan livewire:make admin::"$@"; }
lcona() { php artisan livewire:convert admin::"$@"; }

lcu() { php artisan livewire:make user::"$@"; }
lconu() { php artisan livewire:convert user::"$@"; }

# Optimization
alias pac="php artisan optimize:clear"

# Routes
parl() { php artisan route:list "$@"; }
parln() { php artisan route:list --name="$@"; }
alias parlnc="php artisan route:list --except-path=_debugbar,livewire"

# Server
alias pas="php artisan serve"
alias pas3002="php artisan serve --port=3002"

# =============================================================================
# PEST TESTING ALIASES
# =============================================================================

# Basic
pt() { ./vendor/bin/pest "$@"; }
alias ptb="./vendor/bin/pest --bail"
alias ptc="./vendor/bin/pest --compact"
ptd() { ./vendor/bin/pest tests/Feature/"$@"; }
ptf() { ./vendor/bin/pest --filter "$@"; }
alias ptp="./vendor/bin/pest --parallel"

# Combined options
alias ptbc="./vendor/bin/pest --bail --compact"
alias ptcov="./vendor/bin/pest --coverage"
ptcovmin() { ./vendor/bin/pest --coverage --min="$@"; }
alias ptdirty="./vendor/bin/pest --dirty"
alias ptfast="./vendor/bin/pest --parallel --bail --compact"
alias ptpc="./vendor/bin/pest --parallel --compact"

# Specific test files
alias ptform="./vendor/bin/pest tests/Feature/Livewire/ResourceFormTest.php"
alias ptindex="./vendor/bin/pest tests/Feature/Livewire/ResourceIndexTest.php"
alias ptiso="./vendor/bin/pest tests/Feature/IsolatedTest.php"
