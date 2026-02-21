# SharkTerminal Design

Date: 2026-02-21
Status: Approved
Owner: fishern2000

## 1. Goal
Create a standalone, first-run friendly terminal customization repo focused on fish shell with a shark-branded look and strong daily-driver tooling. It must be easy to install, safe to rerun, and easy to remove.

## 2. Scope
In scope:
- fish-first terminal setup with Oh My Posh default and Tide fallback
- cross-platform installers for Linux, macOS, and Windows/WSL
- dependency installation and verification
- prompt/theme installation
- fish plugins via fisher
- aliases, functions, and quality-of-life CLI tools
- profile switching (`shark`, `clean`, `tide`)
- full README with setup, commands, and troubleshooting

Out of scope (initial release):
- deep distro-specific theming for every Linux flavor
- remote telemetry/analytics
- GUI installers

## 3. Architecture
Top-level structure:
- `README.md`: quick-start, features, commands, troubleshooting
- `install.sh`: Linux/macOS entrypoint
- `install.ps1`: Windows/WSL entrypoint
- `uninstall.sh`: remove configs and restore backup
- `scripts/`: OS installers, verifiers, profile switching
- `config/fish/`: fish config templates, aliases, functions
- `themes/`: Oh My Posh themes including shark theme
- `docs/`: install notes and command reference

## 4. Components
### 4.1 Installers
- `install.sh`
  - parses flags: `--minimal`, `--full`, `--dry-run`
  - detects OS and routes to `scripts/os/*.sh`
  - installs config and runs verification
- `install.ps1`
  - handles Windows/WSL dependencies and fish config deployment

### 4.2 Dependency layer
- Linux package-manager support: `apt`, `dnf`, `pacman` (best effort)
- macOS support: `brew`
- Windows support: `winget` (best effort)
- installs core tools:
  - `fish`, `git`, `curl`, `wget`, `unzip`, `fzf`, `zoxide`, `eza`, `bat`, `ripgrep`, `fd`, `btop`, `tmux`, `fastfetch`, `delta`

### 4.3 Fish runtime
- installs fisher plugin manager
- installs plugins:
  - `jorgebucaran/fisher`
  - `PatrickF1/fzf.fish`
  - `jethrokuan/z`
  - `meaningful-ooo/sponge`
  - `franciscolourenco/done`
  - `ilancosman/tide`
- writes:
  - `~/.config/fish/config.fish`
  - `~/.config/fish/conf.d/*.fish`
  - `~/.config/fish/functions/*.fish`

### 4.4 Prompt and themes
- installs Oh My Posh binary
- installs Nerd Font (MesloLGS NF by default)
- deploys `themes/shark.omp.json`
- enables profile modes:
  - `shark`: fish greeting + shark prompt style + rich prompt modules
  - `clean`: minimal prompt and lean aliases
  - `tide`: Tide prompt setup if OMP unavailable

### 4.5 Safety and recovery
- backup existing fish config into timestamped directory
- idempotent writes and guarded appends
- uninstall script can restore latest backup

## 5. Data Flow
Install path:
1. User runs installer
2. Installer detects OS + mode
3. Dependencies install
4. Fish + fisher + plugins install
5. Theme + font + config deploy
6. Verification script checks command availability and shell config health
7. Outputs exact next commands

Switch profile path:
1. User runs `scripts/switch-profile.sh shark|clean|tide`
2. Script updates active prompt config symlink or include file
3. Re-sources fish config

## 6. Error Handling
- Fail fast for hard requirements (`git`, `curl`/`wget`, shell write permissions)
- Warn and continue for optional packages
- If OMP install fails, auto-fallback to Tide profile and print remediation
- clear non-zero exit codes and human-readable messages

## 7. Testing and Verification
Verification script checks:
- binaries installed and in PATH
- fish config parses
- fisher plugins installed
- active prompt profile valid
- theme file exists

Manual smoke tests:
- open new terminal and confirm greeting/prompt
- run alias checks: `ll`, `cat`, `gs`
- run plugin checks: `fzf`, `zoxide` navigation

## 8. Success Criteria
- fresh machine can run one install command and get a working fish setup
- rerunning install does not duplicate or break config
- uninstall restores previous fish config
- README enables a new user to install and customize without external docs
