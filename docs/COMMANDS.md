# Commands

## Install
- Linux/macOS full: `bash install.sh --full --profile shark`
- Linux/macOS minimal: `bash install.sh --minimal --profile clean`
- Linux/macOS dry-run: `bash install.sh --dry-run --full --profile shark`
- Windows dry-run: `pwsh -File .\\install.ps1 -DryRun -Full -Profile shark`

## Profiles
- Switch (bash): `bash scripts/switch-profile.sh shark`
- Switch (bash): `bash scripts/switch-profile.sh clean`
- Switch (bash): `bash scripts/switch-profile.sh tide`
- Switch (PowerShell): `pwsh -File .\\scripts\\switch-profile.ps1 -Profile shark`

## Verify and Remove
- Verify setup: `bash scripts/verify.sh`
- Uninstall and restore latest backup: `bash uninstall.sh`

## Shell Handoff
- Disable auto-handoff for current terminal: `export SHARKTERMINAL_NO_HANDOFF=1`
- Remove managed handoff block from `.bashrc`: `sed -i '/# >>> SharkTerminal fish handoff >>>/,/# <<< SharkTerminal fish handoff <<</d' ~/.bashrc`
- Remove managed handoff block from `.zshrc`: `sed -i '/# >>> SharkTerminal fish handoff >>>/,/# <<< SharkTerminal fish handoff <<</d' ~/.zshrc`

## Daily fish shortcuts
- `ll` -> `eza -lh --git`
- `la` -> `eza -lah --git`
- `ls` -> `eza`
- `cat` -> `bat --style=plain`
- `gs` -> `git status -sb`
- `ga` -> `git add`
- `gc` -> `git commit`
- `gp` -> `git push`
- `gpl` -> `git pull --rebase`
