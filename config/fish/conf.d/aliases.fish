#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Default fish aliases for navigation, listing, and git workflow quality-of-life improvements.
#################################################################################################
# Quality-of-life aliases
alias ll='eza -lh --git'
alias la='eza -lah --git'
alias ls='eza'
alias cat='bat --style=plain'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull --rebase'
alias ..='cd ..'
alias ...='cd ../..'
