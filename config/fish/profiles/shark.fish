#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Shark profile prompt config using Oh My Posh by default and Tide fallback when needed.
#################################################################################################
# Shark profile: Oh My Posh default
if type -q oh-my-posh
    oh-my-posh init fish --config ~/.config/fish/themes/shark.omp.json | source
else if type -q tide
    tide configure --auto --style=Classic --prompt_colors='True color' --show_time=No --classic_prompt_color=Blue --transient=Yes >/dev/null 2>&1
end
