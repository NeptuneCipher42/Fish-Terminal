#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Main Linux/macOS installer entrypoint for SharkTerminal; parses install modes, routes OS installers, and orchestrates setup stages.
#################################################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${ROOT_DIR}/scripts/lib/log.sh"
source "${ROOT_DIR}/scripts/lib/common.sh"
source "${ROOT_DIR}/scripts/os/linux.sh"
source "${ROOT_DIR}/scripts/os/macos.sh"

MODE="full"
DRY_RUN="0"
PROFILE="shark"

usage() {
  cat <<USAGE
Usage: ./install.sh [--minimal|--full] [--dry-run] [--profile shark|clean|tide]
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --minimal)
      MODE="minimal"
      shift
      ;;
    --full)
      MODE="full"
      shift
      ;;
    --dry-run)
      DRY_RUN="1"
      shift
      ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
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

OS="$(detect_os)"
info "SharkTerminal installer"
info "Detected OS: $OS"
info "Mode: $MODE"
info "Profile: $PROFILE"

if [[ "$DRY_RUN" == "1" ]]; then
  info "Dry run enabled"
fi

case "$OS" in
  linux)
    install_linux_packages "$MODE" "$DRY_RUN"
    ;;
  macos)
    install_macos_packages "$MODE" "$DRY_RUN"
    ;;
  *)
    die "Unsupported OS for install.sh: $OS (use install.ps1 on Windows)"
    ;;
esac

if [[ "$DRY_RUN" == "1" ]]; then
  echo "[DRY-RUN] Would run: scripts/install/tools.sh $MODE"
  echo "[DRY-RUN] Would run: scripts/install/fish.sh $PROFILE"
  echo "[DRY-RUN] Would run: scripts/install/omp.sh"
  echo "[DRY-RUN] Would run: scripts/install/fonts.sh"
  echo "[DRY-RUN] Would run: scripts/verify.sh"
  ok "Dry-run completed"
  exit 0
fi

bash "${ROOT_DIR}/scripts/install/tools.sh" "$MODE"
bash "${ROOT_DIR}/scripts/install/fish.sh" "$PROFILE"
bash "${ROOT_DIR}/scripts/install/omp.sh"
bash "${ROOT_DIR}/scripts/install/fonts.sh"
bash "${ROOT_DIR}/scripts/verify.sh"
ok "Installation completed"
