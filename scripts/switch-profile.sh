#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Profile switch helper for fish prompt modes; applies shark, clean, or tide profile to active configuration.
#################################################################################################

set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE="${1:-}"
TARGET_DIR="${HOME}/.config/fish"
ACTIVE_FILE="${TARGET_DIR}/conf.d/active-profile.fish"

if [[ -z "$PROFILE" ]]; then
  echo "Usage: scripts/switch-profile.sh shark|clean|tide"
  exit 1
fi

case "$PROFILE" in
  shark|clean|tide) ;;
  *) echo "Invalid profile: $PROFILE"; exit 1 ;;
esac

mkdir -p "${TARGET_DIR}/conf.d" "${TARGET_DIR}/profiles"
cp "${ROOT_DIR}/config/fish/profiles/${PROFILE}.fish" "${TARGET_DIR}/profiles/${PROFILE}.fish"
cp "${TARGET_DIR}/profiles/${PROFILE}.fish" "$ACTIVE_FILE"

echo "Switched profile to: $PROFILE"
