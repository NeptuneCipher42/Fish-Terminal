#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Uninstall and restore script that removes active fish config and restores the latest timestamped backup.
#################################################################################################
set -euo pipefail

TARGET_DIR="$HOME/.config/fish"
BACKUP_ROOT="$HOME/.config/fish.backups"

if [[ -d "$TARGET_DIR" ]]; then
  rm -rf "$TARGET_DIR"
  echo "[INFO] Removed current fish config"
fi

LATEST_BACKUP=""
if [[ -d "$BACKUP_ROOT" ]]; then
  LATEST_BACKUP="$(ls -1 "$BACKUP_ROOT" 2>/dev/null | sort | tail -n1 || true)"
fi

if [[ -n "$LATEST_BACKUP" ]]; then
  mkdir -p "$TARGET_DIR"
  cp -a "$BACKUP_ROOT/$LATEST_BACKUP/." "$TARGET_DIR/"
  echo "[ OK ] Restored backup from $BACKUP_ROOT/$LATEST_BACKUP"
else
  echo "[WARN] No backup found to restore"
fi
