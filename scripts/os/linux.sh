#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Linux dependency installer with package manager detection for apt, dnf, and pacman.
#################################################################################################

install_linux_packages() {
  local mode="$1" dry_run="$2"
  local base_pkgs=(fish git curl wget unzip fzf zoxide eza bat ripgrep fd-find btop tmux)
  local full_only=(delta)
  local pkgs=("${base_pkgs[@]}")

  if [[ "$mode" == "full" ]]; then
    pkgs+=("${full_only[@]}")
  fi

  if command -v apt-get >/dev/null 2>&1; then
    if [[ "$dry_run" == "1" ]]; then
      echo "[DRY-RUN] apt packages: ${pkgs[*]}"
      echo "[DRY-RUN] optional apt packages: fastfetch or neofetch"
    else
      sudo apt-get update
      sudo apt-get install -y "${pkgs[@]}"
      if ! sudo apt-get install -y fastfetch; then
        echo "[WARN] fastfetch package not available; trying neofetch"
        sudo apt-get install -y neofetch || echo "[WARN] Could not install fastfetch or neofetch"
      fi
    fi
    return 0
  fi

  if command -v dnf >/dev/null 2>&1; then
    if [[ "$dry_run" == "1" ]]; then
      echo "[DRY-RUN] dnf packages: ${pkgs[*]}"
      echo "[DRY-RUN] optional dnf package: fastfetch"
    else
      sudo dnf install -y "${pkgs[@]}"
      sudo dnf install -y fastfetch || echo "[WARN] fastfetch unavailable in dnf repositories"
    fi
    return 0
  fi

  if command -v pacman >/dev/null 2>&1; then
    if [[ "$dry_run" == "1" ]]; then
      echo "[DRY-RUN] pacman packages: ${pkgs[*]}"
      echo "[DRY-RUN] optional pacman package: fastfetch"
    else
      sudo pacman -Sy --noconfirm "${pkgs[@]}"
      sudo pacman -Sy --noconfirm fastfetch || echo "[WARN] fastfetch unavailable in pacman repositories"
    fi
    return 0
  fi

  echo "[WARN] No supported Linux package manager found"
}
