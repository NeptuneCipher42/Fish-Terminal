#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# macOS dependency installer powered by Homebrew with minimal/full mode package sets.
#################################################################################################

install_macos_packages() {
  local mode="$1" dry_run="$2"
  local base_pkgs=(fish git curl wget fzf zoxide eza bat ripgrep fd btop tmux fastfetch)
  local full_only=(git-delta)
  local pkgs=("${base_pkgs[@]}")

  if [[ "$mode" == "full" ]]; then
    pkgs+=("${full_only[@]}")
  fi

  if ! command -v brew >/dev/null 2>&1; then
    echo "[ERR ] Homebrew is required on macOS"
    return 1
  fi

  if [[ "$dry_run" == "1" ]]; then
    echo "[DRY-RUN] brew packages: ${pkgs[*]}"
    return 0
  fi

  brew update
  brew install "${pkgs[@]}" || true
}
