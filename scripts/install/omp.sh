#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Oh My Posh installation stage with safe fallback behavior when network or install fails.
#################################################################################################
set -euo pipefail

if command -v oh-my-posh >/dev/null 2>&1; then
  echo "[ OK ] oh-my-posh already installed"
  exit 0
fi

if command -v curl >/dev/null 2>&1; then
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin" || {
    echo "[WARN] Failed to install oh-my-posh; Tide fallback remains available"
    exit 0
  }
else
  echo "[WARN] curl not available; skipping oh-my-posh install"
fi
