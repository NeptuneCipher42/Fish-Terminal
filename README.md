# SharkTerminal
<img width="854" height="389" alt="image" src="https://github.com/user-attachments/assets/941699db-36a0-4079-9c21-b0c28cbefae4" />
Fish-first terminal customization with shark vibes, Oh My Posh default, Tide fallback, plugin automation, and cross-platform install scripts.

## Quick Start

### Linux/macOS
```bash
git clone https://github.com/NeptuneCipher42/Fish-Terminal.git SharkTerminal
cd SharkTerminal
bash install.sh --full --profile shark
```
**Important Note: Add `exec fish` to `.bashrc` or `.zshrc` to start fishterm on terminal boot.**

## What You Get
- Fish-centric terminal setup with shark-themed greeting and prompt
- Custom FISHTERM shark ASCII startup banner on terminal open
- Oh My Posh default theme plus Tide fallback profile
- Fisher plugins preconfigured
- Useful modern CLI tools and Git shortcuts
- Profile switching (`shark`, `clean`, `tide`)
- Safe backups and uninstall restore

## Profiles
- `shark`: full shark aesthetic + OMP prompt
- `clean`: minimal prompt and lean visuals
- `tide`: native fish prompt fallback

Switch profiles:
```bash
bash scripts/switch-profile.sh shark
bash scripts/switch-profile.sh clean
bash scripts/switch-profile.sh tide
```
## Fish Plugins
Defined in `config/fish/plugins.txt`:
- `jorgebucaran/fisher`
- `PatrickF1/fzf.fish`
- `jethrokuan/z`
- `meaningful-ooo/sponge`
- `franciscolourenco/done`
- `ilancosman/tide`

## Main Commands
- Full install: `bash install.sh --full --profile shark`
- Minimal install: `bash install.sh --minimal --profile clean`
- Dry-run install: `bash install.sh --dry-run --full --profile shark`
- Verify: `bash scripts/verify.sh`
- Uninstall/restore: `bash uninstall.sh`

See full command list in `docs/COMMANDS.md`.

## Structure
- `install.sh`: Linux/macOS entrypoint
- `install.ps1`: Windows entrypoint
- `scripts/os/*`: OS-specific dependency installers
- `scripts/install/*`: config and prompt install internals
- `config/fish/*`: fish config, aliases, profiles, plugin list
- `themes/*`: Oh My Posh themes
- `docs/*`: command and troubleshooting docs

## Notes
- Run installers again anytime; they are designed to be re-runnable.
- Existing fish config is backed up under `~/.config/fish.backups/`.
- If OMP fails to install, switch to Tide profile and continue.
- Installer adds a managed fish handoff block to `~/.bashrc` (and `~/.zshrc` if present) so new terminals auto-enter fish.
- Temporarily bypass handoff with `export SHARKTERMINAL_NO_HANDOFF=1`.
