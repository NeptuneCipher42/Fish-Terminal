#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Linux dependency installer with package manager detection for apt, dnf, and pacman.
# Handles Debian/Ubuntu quirks: eza binary install, bat→batcat, fd-find→fdfind aliases.
#################################################################################################

# Install eza from the official gierens apt repo, or fall back to binary download
_install_eza_apt() {
  local dry_run="$1"
  if [[ "$dry_run" == "1" ]]; then
    echo "[DRY-RUN] Would install eza via gierens apt repo or binary"
    return 0
  fi
  # Try the official eza apt repo first
  if sudo apt-get install -y gpg 2>/dev/null; then
    mkdir -p /etc/apt/keyrings
    if curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
         | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null && \
       echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
         | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null && \
       sudo apt-get update -qq && \
       sudo apt-get install -y eza 2>/dev/null; then
      echo "[INFO] eza installed via gierens repo"
      return 0
    fi
  fi
  # Fallback: download binary from GitHub releases
  echo "[INFO] Falling back to eza binary download"
  local arch
  arch="$(uname -m)"
  local eza_target="eza_${arch}-unknown-linux-gnu.tar.gz"
  local eza_url="https://github.com/eza-community/eza/releases/latest/download/${eza_target}"
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  if curl -fsSL "$eza_url" -o "${tmp_dir}/eza.tar.gz" && \
     tar -xzf "${tmp_dir}/eza.tar.gz" -C "$tmp_dir" 2>/dev/null; then
    sudo install -m755 "${tmp_dir}/eza" /usr/local/bin/eza
    echo "[INFO] eza installed to /usr/local/bin/eza"
  else
    echo "[WARN] Could not install eza — skipping"
  fi
  rm -rf "$tmp_dir"
}

# Install git-delta from GitHub releases (not in Debian/Ubuntu repos)
_install_delta_apt() {
  local dry_run="$1"
  if [[ "$dry_run" == "1" ]]; then
    echo "[DRY-RUN] Would install git-delta binary"
    return 0
  fi
  local arch
  arch="$(uname -m)"
  # delta releases use x86_64 / aarch64
  local delta_url="https://github.com/dandavison/delta/releases/latest/download/delta-latest-${arch}-unknown-linux-gnu.tar.gz"
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  if curl -fsSL "$delta_url" -o "${tmp_dir}/delta.tar.gz" && \
     tar -xzf "${tmp_dir}/delta.tar.gz" -C "$tmp_dir" --strip-components=1 2>/dev/null; then
    sudo install -m755 "${tmp_dir}/delta" /usr/local/bin/delta
    echo "[INFO] delta installed to /usr/local/bin/delta"
  else
    echo "[WARN] Could not install delta — skipping"
  fi
  rm -rf "$tmp_dir"
}

# Install zoxide — try apt first, fall back to the official install script
_install_zoxide_apt() {
  local dry_run="$1"
  if [[ "$dry_run" == "1" ]]; then
    echo "[DRY-RUN] Would install zoxide"
    return 0
  fi
  if sudo apt-get install -y zoxide 2>/dev/null; then
    echo "[INFO] zoxide installed via apt"
  else
    echo "[INFO] zoxide not in apt repos; using official install script"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  fi
}

# Create bat / fd symlinks for Debian (packages install as batcat / fdfind)
_fix_debian_aliases() {
  local dry_run="$1"
  if [[ "$dry_run" == "1" ]]; then
    echo "[DRY-RUN] Would create bat/fd symlinks for Debian"
    return 0
  fi
  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    sudo ln -sf "$(command -v batcat)" /usr/local/bin/bat
    echo "[INFO] Created /usr/local/bin/bat → batcat"
  fi
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    echo "[INFO] Created /usr/local/bin/fd → fdfind"
  fi
}

install_linux_packages() {
  local mode="$1" dry_run="$2"

  # eza, delta, zoxide installed separately below (not in standard Debian repos)
  local base_pkgs=(fish git curl wget unzip fzf bat ripgrep fd-find btop tmux)
  local full_only=()
  local pkgs=("${base_pkgs[@]}")

  if [[ "$mode" == "full" ]]; then
    pkgs+=("${full_only[@]}")
  fi

  # ── apt (Debian / Ubuntu) ────────────────────────────────────────────────
  if command -v apt-get >/dev/null 2>&1; then
    if [[ "$dry_run" == "1" ]]; then
      echo "[DRY-RUN] apt packages: ${pkgs[*]}"
      echo "[DRY-RUN] optional: fastfetch/neofetch, eza, delta, zoxide"
    else
      sudo apt-get update
      sudo apt-get install -y "${pkgs[@]}"
      if ! sudo apt-get install -y fastfetch 2>/dev/null; then
        echo "[WARN] fastfetch not available; trying neofetch"
        sudo apt-get install -y neofetch || echo "[WARN] Could not install fastfetch or neofetch"
      fi
      _fix_debian_aliases "$dry_run"
      _install_eza_apt "$dry_run"
      if [[ "$mode" == "full" ]]; then
        _install_delta_apt "$dry_run"
      fi
      _install_zoxide_apt "$dry_run"
    fi
    return 0
  fi

  # ── dnf (Fedora / RHEL) ─────────────────────────────────────────────────
  if command -v dnf >/dev/null 2>&1; then
    local dnf_pkgs=(fish git curl wget unzip fzf bat ripgrep fd-find btop tmux zoxide eza)
    [[ "$mode" == "full" ]] && dnf_pkgs+=(git-delta)
    if [[ "$dry_run" == "1" ]]; then
      echo "[DRY-RUN] dnf packages: ${dnf_pkgs[*]}"
    else
      sudo dnf install -y "${dnf_pkgs[@]}"
      sudo dnf install -y fastfetch || echo "[WARN] fastfetch unavailable in dnf repositories"
    fi
    return 0
  fi

  # ── pacman (Arch) ────────────────────────────────────────────────────────
  if command -v pacman >/dev/null 2>&1; then
    local pac_pkgs=(fish git curl wget unzip fzf bat ripgrep fd btop tmux zoxide eza)
    [[ "$mode" == "full" ]] && pac_pkgs+=(git-delta)
    if [[ "$dry_run" == "1" ]]; then
      echo "[DRY-RUN] pacman packages: ${pac_pkgs[*]}"
    else
      sudo pacman -Sy --noconfirm "${pac_pkgs[@]}"
      sudo pacman -Sy --noconfirm fastfetch || echo "[WARN] fastfetch unavailable in pacman repositories"
    fi
    return 0
  fi

  echo "[WARN] No supported Linux package manager found"
}
