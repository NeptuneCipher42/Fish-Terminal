#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: March 24th 2026
# Description of Script
# Lightweight config-only updater for SharkTerminal. Pulls latest repo changes and redeploys
# fish config, profiles, banners, and themes without reinstalling OS packages.
# Safe to run on headless Debian/Ubuntu servers.
#################################################################################################
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${ROOT_DIR}/scripts/lib/log.sh"

PROFILE="shark"

usage() {
  cat <<USAGE
Usage: ./update.sh [--profile shark|clean|tide] [--no-pull]

  --profile   Fish profile to activate (default: shark)
  --no-pull   Skip git pull (use current repo state)
USAGE
}

NO_PULL="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      PROFILE="${2:-shark}"
      shift 2
      ;;
    --no-pull)
      NO_PULL="1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown flag: $1"
      ;;
  esac
done

case "$PROFILE" in
  shark|clean|tide) ;;
  *) die "Invalid profile '$PROFILE'. Use shark, clean, or tide." ;;
esac

info "SharkTerminal updater"
info "Profile: $PROFILE"

# Pull latest changes unless skipped
if [[ "$NO_PULL" == "0" ]]; then
  if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    info "Pulling latest changes from git..."
    git -C "$ROOT_DIR" pull --ff-only || {
      echo "[WARN] git pull failed; continuing with current repo state"
    }
  else
    echo "[WARN] Not a git repo; skipping pull"
  fi
fi

TARGET_DIR="${HOME}/.config/fish"
BACKUP_ROOT="${HOME}/.config/fish.backups"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${STAMP}"

mkdir -p "${BACKUP_ROOT}"

# Back up existing config
if [[ -d "${TARGET_DIR}" ]]; then
  mkdir -p "${BACKUP_DIR}"
  cp -a "${TARGET_DIR}/." "${BACKUP_DIR}/"
  info "Backed up existing fish config to ${BACKUP_DIR}"
fi

# Deploy config files
mkdir -p "${TARGET_DIR}/conf.d" "${TARGET_DIR}/functions" "${TARGET_DIR}/profiles" "${TARGET_DIR}/themes" "${TARGET_DIR}/banner"
cp "${ROOT_DIR}/config/fish/config.fish"                         "${TARGET_DIR}/config.fish"
cp "${ROOT_DIR}/config/fish/conf.d/aliases.fish"                 "${TARGET_DIR}/conf.d/aliases.fish"
cp "${ROOT_DIR}/config/fish/conf.d/env.fish"                     "${TARGET_DIR}/conf.d/env.fish"
cp "${ROOT_DIR}/config/fish/functions/fish_greeting.fish"        "${TARGET_DIR}/functions/fish_greeting.fish"
cp "${ROOT_DIR}/config/fish/banner/"*.txt                        "${TARGET_DIR}/banner/"
cp "${ROOT_DIR}/config/fish/profiles/"*.fish                     "${TARGET_DIR}/profiles/"
cp "${ROOT_DIR}/themes/"*.omp.json                               "${TARGET_DIR}/themes/"
cp "${TARGET_DIR}/profiles/${PROFILE}.fish"                      "${TARGET_DIR}/conf.d/active-profile.fish"

info "Fish config files deployed"

# Update/install fisher and plugins if fish is available
if command -v fish >/dev/null 2>&1; then
  # Install fisher if missing (uses direct URL — git.io is deprecated)
  if ! fish -c "type -q fisher" >/dev/null 2>&1; then
    info "Installing fisher..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" || \
      echo "[WARN] Could not install fisher; prompt plugins may be missing"
  fi

  # Install/update plugins
  if fish -c "type -q fisher" >/dev/null 2>&1; then
    info "Updating fisher plugins..."
    while IFS= read -r plugin; do
      [[ -z "$plugin" ]] && continue
      fish -c "fisher install $plugin" || echo "[WARN] Could not install plugin: $plugin"
    done < "${ROOT_DIR}/config/fish/plugins.txt"
  else
    echo "[WARN] fisher not available; skipping plugin update"
  fi
else
  echo "[WARN] fish not found; skipping plugin update"
fi

# Install/update oh-my-posh if curl available (headless-safe)
if ! command -v oh-my-posh >/dev/null 2>&1; then
  if command -v curl >/dev/null 2>&1; then
    info "Installing oh-my-posh..."
    mkdir -p "${HOME}/.local/bin"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "${HOME}/.local/bin" || \
      echo "[WARN] oh-my-posh install failed; prompt will fall back to tide or minimal"
  fi
else
  info "oh-my-posh already installed"
fi

ok "SharkTerminal update complete — open a new fish shell to apply changes"
