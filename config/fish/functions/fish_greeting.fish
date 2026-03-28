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
    if test -z "$term_width"; or test "$term_width" -eq 0
        set term_width 80
    end
    echo ""
    set_color BD93F9
    echo "🐙  Cracken's Cavern  🐙"
    set_color normal
    echo ""
    if test -f "$kraken_banner"; and test -f "$fishterm_banner"
        if test "$term_width" -ge 76
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
                    set_color BD93F9
                    printf "%-30s" "$left"
                    if test (math "$i % 2") -eq 1
                        set_color FF79C6
                    else
                        set_color C8A0FF
                    end
                    printf "  %s\n" "$right"
                else
                    set_color BD93F9
                    printf "%s\n" "$left"
                end
            end
        else
            set_color BD93F9
            command cat "$kraken_banner"
            set_color FF79C6
            command cat "$fishterm_banner"
        end
        set_color normal
    else
        set_color FF79C6
        echo "FISHTERM"
        set_color normal
    end
    echo ""
end
