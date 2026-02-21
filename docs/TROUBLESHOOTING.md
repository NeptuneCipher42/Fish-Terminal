# Troubleshooting

## Nerd Font icons look broken
- Set terminal font to `MesloLGS Nerd Font`.
- Restart terminal after install.

## `oh-my-posh` not found
- Run `bash scripts/install/omp.sh`.
- If install fails, use Tide fallback: `bash scripts/switch-profile.sh tide`.

## `fish` not starting by default
- Set login shell manually: `chsh -s $(which fish)`.
- Log out and back in.

## Plugins did not install
- Ensure fish exists: `fish --version`.
- Re-run plugin layer: `bash scripts/install/fish.sh shark`.

## Missing tools after install
- Run `bash install.sh --dry-run` to inspect package actions.
- Install missing tools manually if your distro package names differ.

## Undo everything
- Run `bash uninstall.sh` to remove current fish config and restore latest backup.
