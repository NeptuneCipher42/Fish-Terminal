#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Custom shark-themed fish greeting function displayed at interactive shell start.
#################################################################################################
function fish_greeting
    set -l kraken_banner "$HOME/.config/fish/banner/kraken.txt"
    set -l fishterm_banner "$HOME/.config/fish/banner/fishterm.txt"
    set -l term_width $COLUMNS
    if test -z "$term_width"
        set term_width 120
    end
    echo ""
    if test -f "$kraken_banner"; and test -f "$fishterm_banner"
        if test "$term_width" -ge 145
            set -l left_lines (string split \n -- (command cat "$kraken_banner"))
            set -l right_lines (string split \n -- (command cat "$fishterm_banner"))
            set -l max_lines (math "max(" (count $left_lines) "," (count $right_lines) ")")

            for i in (seq 1 $max_lines)
                set -l left ""
                set -l right ""
                if test $i -le (count $left_lines)
                    set left $left_lines[$i]
                end
                if test $i -le (count $right_lines)
                    set right $right_lines[$i]
                end

                if test -n "$right"
                    set_color 5fd7ff
                    printf "%-36s" "$left"
                    set_color brblue
                    printf "  %s\n" "$right"
                else
                    set_color 5fd7ff
                    printf "%s\n" "$left"
                end
            end
        else
            set_color 5fd7ff
            command cat "$kraken_banner"
            set_color brblue
            command cat "$fishterm_banner"
        end
        set_color normal
    else
        set_color brblue
        echo "FISHTERM"
        set_color normal
    end
    echo ""
end
