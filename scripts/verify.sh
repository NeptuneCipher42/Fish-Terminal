#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Post-install verification checks for required binaries, optional tools, and fish profile/theme presence.
#################################################################################################
set -euo pipefail

required=(fish git curl)
optional=(oh-my-posh fzf zoxide eza bat rg fd tmux btop fastfetch)

echo "[INFO] Running SharkTerminal verification"

for bin in "${required[@]}"; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "[ OK ] found: $bin"
  else
    echo "[ERR ] missing required: $bin"
  fi
done

for bin in "${optional[@]}"; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "[ OK ] found optional: $bin"
  else
    echo "[WARN] missing optional: $bin"
  fi
done

if command -v fish >/dev/null 2>&1; then
  fish -n "$HOME/.config/fish/config.fish" >/dev/null 2>&1 && echo "[ OK ] fish config syntax valid" || echo "[WARN] fish config not found or invalid"
fi

if [[ -f "$HOME/.config/fish/conf.d/active-profile.fish" ]]; then
  echo "[ OK ] active profile present"
else
  echo "[WARN] active profile missing"
fi

if [[ -f "$HOME/.config/fish/themes/shark.omp.json" ]]; then
  echo "[ OK ] shark theme installed"
else
  echo "[WARN] shark theme missing"
fi

if [[ -f "$HOME/.config/fish/banner/kraken.txt" && -f "$HOME/.config/fish/banner/fishterm.txt" ]]; then
  echo "[ OK ] fishterm kraken banner installed"
else
  echo "[WARN] fishterm kraken banner missing"
fi
