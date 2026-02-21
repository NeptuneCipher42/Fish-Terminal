#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Clean profile prompt config for minimal visual style with lightweight prompt fallback.
#################################################################################################
# Clean profile: minimal prompt
if type -q oh-my-posh
    oh-my-posh init fish --config ~/.config/fish/themes/clean.omp.json | source
else
    function fish_prompt
        set_color cyan
        echo -n (prompt_pwd) ' > '
        set_color normal
    end
end
