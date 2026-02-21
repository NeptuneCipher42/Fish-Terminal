#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Primary fish runtime config that sources environment, aliases, and currently active profile.
#################################################################################################
# SharkTerminal main fish config

if status is-interactive
    if test -f ~/.config/fish/conf.d/env.fish
        source ~/.config/fish/conf.d/env.fish
    end

    if test -f ~/.config/fish/conf.d/aliases.fish
        source ~/.config/fish/conf.d/aliases.fish
    end

    if test -f ~/.config/fish/conf.d/active-profile.fish
        source ~/.config/fish/conf.d/active-profile.fish
    else if test -f ~/.config/fish/profiles/shark.fish
        source ~/.config/fish/profiles/shark.fish
    end
end
