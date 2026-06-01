#!/usr/bin/env bash

# =============================================================================
# FORGE / REMOTE SERVER
# =============================================================================

alias sshforge="ssh -t $SSH_USER@$SERVER_IP"
alias sshfol="ssh -t $SSH_USER@$SERVER_IP 'cd /home/forge/factsoflife.com.au && bash -l'"
alias sshfold="ssh -t $SSH_USER@$SERVER_IP 'cd /home/forge/fol.on-forge.com && bash -l'"
alias sshnkfol="ssh -t $SSH_USER@$SERVER_IP 'cd /home/forge/nk.on-forge.com && bash -l'"

# =============================================================================
# SCRIPTS
# =============================================================================

alias bu-dbase="bash $SCRIPTS/backup-db.sh"
alias bu-files="bash $SCRIPTS/backup-files.sh"
alias dblogin="bash $SCRIPTS/mysql-login.sh"
alias fix-line-endings="bash $SCRIPTS/fix-line-endings.sh"
