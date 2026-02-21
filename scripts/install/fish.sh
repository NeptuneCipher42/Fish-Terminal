#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Fish deployment stage that backs up existing config, installs templates, and provisions fisher plugins.
#################################################################################################
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROFILE="${1:-shark}"
TARGET_DIR="${HOME}/.config/fish"
BACKUP_ROOT="${HOME}/.config/fish.backups"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${STAMP}"
HANDOFF_START="# >>> SharkTerminal fish handoff >>>"
HANDOFF_END="# <<< SharkTerminal fish handoff <<<"

install_shell_handoff_block() {
  local rc_file="$1"
  [[ -f "$rc_file" ]] || touch "$rc_file"

  if grep -qF "$HANDOFF_START" "$rc_file"; then
    return 0
  fi

  cat >> "$rc_file" <<EOF

$HANDOFF_START
# Auto-enter fish for interactive shells unless explicitly disabled.
if [ -z "\$SHARKTERMINAL_NO_HANDOFF" ] && [ -t 1 ] && command -v fish >/dev/null 2>&1; then
  case "\$-" in
    *i*) [ "\${SHELL##*/}" != "fish" ] && [ -z "\$FISH_VERSION" ] && exec fish ;;
  esac
fi
$HANDOFF_END
EOF
}

mkdir -p "${BACKUP_ROOT}"

if [[ -d "${TARGET_DIR}" ]]; then
  mkdir -p "${BACKUP_DIR}"
  cp -a "${TARGET_DIR}/." "${BACKUP_DIR}/"
  echo "[INFO] Backed up existing fish config to ${BACKUP_DIR}"
fi

mkdir -p "${TARGET_DIR}/conf.d" "${TARGET_DIR}/functions" "${TARGET_DIR}/profiles" "${TARGET_DIR}/themes" "${TARGET_DIR}/banner"
cp "${ROOT_DIR}/config/fish/config.fish" "${TARGET_DIR}/config.fish"
cp "${ROOT_DIR}/config/fish/conf.d/aliases.fish" "${TARGET_DIR}/conf.d/aliases.fish"
cp "${ROOT_DIR}/config/fish/conf.d/env.fish" "${TARGET_DIR}/conf.d/env.fish"
cp "${ROOT_DIR}/config/fish/functions/fish_greeting.fish" "${TARGET_DIR}/functions/fish_greeting.fish"
cp "${ROOT_DIR}/config/fish/banner/"*.txt "${TARGET_DIR}/banner/"
cp "${ROOT_DIR}/config/fish/profiles/"*.fish "${TARGET_DIR}/profiles/"
cp "${ROOT_DIR}/themes/"*.omp.json "${TARGET_DIR}/themes/"
cp "${TARGET_DIR}/profiles/${PROFILE}.fish" "${TARGET_DIR}/conf.d/active-profile.fish"

install_shell_handoff_block "${HOME}/.bashrc"
if [[ -f "${HOME}/.zshrc" ]]; then
  install_shell_handoff_block "${HOME}/.zshrc"
fi

if command -v fish >/dev/null 2>&1; then
  if ! fish -c "type -q fisher" >/dev/null 2>&1; then
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
  fi
  while IFS= read -r plugin; do
    [[ -z "$plugin" ]] && continue
    fish -c "fisher install $plugin" || true
  done < "${ROOT_DIR}/config/fish/plugins.txt"
else
  echo "[WARN] fish binary not found; skipping fisher plugin installation"
fi

echo "[ OK ] Fish configuration deployed (${PROFILE})"
