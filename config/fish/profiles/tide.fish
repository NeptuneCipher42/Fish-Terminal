#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Tide-only profile configuration for native fish prompt fallback usage.
#################################################################################################
# Tide fallback profile
if type -q tide
    tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --transient=Yes >/dev/null 2>&1
end
