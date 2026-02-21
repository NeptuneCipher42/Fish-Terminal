#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Nerd Font installation stage for Linux/macOS to ensure prompt glyph rendering is correct.
#################################################################################################
set -euo pipefail

FONT_DIR_LINUX="${HOME}/.local/share/fonts"
FONT_DIR_MAC="${HOME}/Library/Fonts"
TMP_DIR="${HOME}/.tmp/sharkterminal-fonts"
mkdir -p "$TMP_DIR"

case "$(uname -s)" in
  Linux)
    mkdir -p "$FONT_DIR_LINUX"
    DEST="$FONT_DIR_LINUX"
    ;;
  Darwin)
    mkdir -p "$FONT_DIR_MAC"
    DEST="$FONT_DIR_MAC"
    ;;
  *)
    echo "[WARN] Font install script supports Linux/macOS only"
    exit 0
    ;;
esac

URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
ZIP_PATH="$TMP_DIR/Meslo.zip"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$URL" -o "$ZIP_PATH" || { echo "[WARN] Could not download Meslo Nerd Font"; exit 0; }
else
  echo "[WARN] curl not available; skipping font install"
  exit 0
fi

if command -v unzip >/dev/null 2>&1; then
  unzip -o "$ZIP_PATH" -d "$DEST" >/dev/null 2>&1 || true
  command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$DEST" >/dev/null 2>&1 || true
  echo "[ OK ] Nerd Font installed to $DEST"
else
  echo "[WARN] unzip not available; skipping font extraction"
fi
