set -gx PATH $HOME/.local/bin $PATH
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Environment defaults and conditional initialization hooks for zoxide and fzf.
#################################################################################################
# Environment defaults
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx BAT_THEME ansi

if type -q zoxide
    zoxide init fish | source
end

if type -q fzf
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
end
