################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Custom shark-themed fish greeting — multicolored Kraken, pink/purple palette.
################################################################################################
function fish_greeting
    set -l kraken_banner "$HOME/.config/fish/banner/kraken.txt"
    set -l fishterm_banner "$HOME/.config/fish/banner/fishterm.txt"
    set -l term_width $COLUMNS
    if test -z "$term_width"; or test "$term_width" -eq 0
        set term_width 80
    end

    # Color palette — octopus cycles through all, FISHTERM alternates pink/purple
    set -l octopus_colors FF79C6 B53AAE BD93F9 E040FB FF79C6 B53AAE BD93F9

    echo ""
    set_color B53AAE
    echo "🐙  Cracken's Cavern  🐙"
    set_color normal
    echo ""

    if test -f "$kraken_banner"; and test -f "$fishterm_banner"
        if test "$term_width" -ge 76
            set -l left_lines (string split \n -- (command cat "$kraken_banner"))
            set -l right_lines (string split \n -- (command cat "$fishterm_banner"))
            set -l max_lines (math "max(" (count $left_lines) "," (count $right_lines) ")")
            set -l num_colors (count $octopus_colors)

            for i in (seq 1 $max_lines)
                set -l left ""
                set -l right ""
                if test $i -le (count $left_lines)
                    set left $left_lines[$i]
                end
                if test $i -le (count $right_lines)
                    set right $right_lines[$i]
                end

                # Cycle octopus through all palette colors
                set -l color_idx (math "($i - 1) % $num_colors + 1")
                set -l oct_color $octopus_colors[$color_idx]

                if test -n "$right"
                    set_color $oct_color
                    printf "%-30s" "$left"
                    if test (math "$i % 2") -eq 1
                        set_color FF79C6
                    else
                        set_color B53AAE
                    end
                    printf "  %s\n" "$right"
                else
                    set_color $oct_color
                    printf "%s\n" "$left"
                end
            end
        else
            set -l num_colors (count $octopus_colors)
            set -l left_lines (string split \n -- (command cat "$kraken_banner"))
            set -l i 1
            for line in $left_lines
                set -l color_idx (math "($i - 1) % $num_colors + 1")
                set_color $octopus_colors[$color_idx]
                echo $line
                set i (math $i + 1)
            end
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
