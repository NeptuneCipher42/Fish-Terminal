<div align="center">

<img width="1252" height="483" alt="SharkTerminal Banner" src="https://github.com/user-attachments/assets/0e9235aa-6e83-4718-b84d-73cfdbd8d702" />

<p><strong>Cracken's Cavern — The Hacker's Terminal</strong></p>

<p>
<img src="https://img.shields.io/badge/Fish_Shell-4E89C5?style=for-the-badge&logo=gnu-bash&logoColor=white" />
<img src="https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white" />
<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
<img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white" />
<img src="https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white" />
<img src="https://img.shields.io/badge/Oh_My_Posh-088F8F?style=for-the-badge&logo=iterm2&logoColor=white" />
</p>

</div>

> A cross-platform shark-themed terminal framework — fish shell + PowerShell, Oh My Posh prompt engine, modern CLI tool replacements, Fisher plugin automation, three switchable profiles, and safe timestamped backups. One command installs everything.

---

## What's Inside

| Category | Stack |
|---|---|
| **Shell (Unix)** | `fish` with Oh My Posh (shark theme) + Tide fallback |
| **Shell (Windows)** | `PowerShell 7+` with matching shark Oh My Posh theme |
| **Prompt Engine** | `oh-my-posh` — powerline prompt, transient mode, git status |
| **Fallback Prompt** | `tide` — native fish prompt engine (lean style) |
| **Plugin Manager** | `fisher` — declarative `plugins.txt` manifest |
| **Fuzzy Finder** | `fzf` + `fzf.fish` / `PSFzf` — `Ctrl+F` files, `Ctrl+R` history |
| **Smart `cd`** | `zoxide` — frecency-based directory jumping (`z <dir>`) |
| **`ls` replacement** | `eza` — colors, git integration, tree view |
| **`cat` replacement** | `bat` — syntax highlighting, git diff support |
| **`find` replacement** | `fd` — faster, respects `.gitignore` |
| **`grep` replacement** | `ripgrep` — blazing fast, recursive by default |
| **Git diff viewer** | `delta` — side-by-side diffs (full install mode) |
| **System monitor** | `btop` — resource viewer |
| **Multiplexer** | `tmux` — terminal session management |
| **Greeting** | Kraken + FISHTERM dual ASCII art banners (Braille unicode) |
| **Profiles** | `shark` (full aesthetic) · `clean` (minimal) · `tide` (native fish) |
| **Themes** | `shark.omp.json` (pink/purple powerline) · `clean.omp.json` (cyan minimal) |
| **Windows Terminal** | `Shark Dark` color scheme fragment (dark navy + Dracula ANSI palette) |

---

## Quick Start

Clone the repo and run one install command for your OS.

### Linux / macOS

```bash
git clone https://github.com/NeptuneCipher42/Fish-Terminal.git SharkTerminal
cd SharkTerminal
bash install.sh --full --profile shark
```

### Windows (PowerShell 7+)

**Step 1 — Install PowerShell 7** (skip if already installed)

```powershell
winget install --id Microsoft.PowerShell --source winget
```

Close and reopen using **PowerShell 7** (`pwsh`) — not Windows PowerShell 5.

**Step 2 — Clone and install**

```powershell
git clone https://github.com/NeptuneCipher42/Fish-Terminal.git SharkTerminal
cd SharkTerminal
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -Full -SharkProfile shark
```

> **Nerd Font required** — install [CaskaydiaCove NF](https://www.nerdfonts.com/) and set it as your terminal font for prompt icons and ASCII banners to render correctly.

---

## Install Modes

| Flag | Effect |
|---|---|
| `--full` / `-Full` | All CLI tools + Oh My Posh + Nerd Fonts + delta + (Windows) neovim |
| `--minimal` / `-Minimal` | Core tools only — fish, git, fzf, zoxide, eza, bat, ripgrep, fd |
| `--dry-run` / `-DryRun` | Preview every action without making changes |
| `--profile shark\|clean\|tide` | Set active profile at install time (default: `shark`) |

---

## After Install

### Fish
```fish
fisher update      # Update all plugins
fish_greeting      # Preview the ASCII greeting
```

### PowerShell
```powershell
Update-Module PSReadLine   # Update core module
# Ctrl+F — file finder
# Ctrl+R — history search
```

### Verify installation
```bash
bash scripts/verify.sh
```

---

## Profiles

| Profile | Fish | PowerShell | Description |
|---|---|---|---|
| `shark` | ✅ | ✅ | Full shark aesthetic — Oh My Posh + Nerd Font icons + ASCII greeting |
| `clean` | ✅ | ✅ | Minimal Oh My Posh theme, lean visuals, no ASCII art |
| `tide` | ✅ | ➡ shark | Native Tide fish prompt (PowerShell falls back to shark) |

Switch profiles at any time — no reinstall needed.

**Fish:**
```bash
bash scripts/switch-profile.sh shark
bash scripts/switch-profile.sh clean
bash scripts/switch-profile.sh tide
```

**PowerShell:**
```powershell
pwsh -File .\scripts\switch-profile.ps1 -Profile shark
pwsh -File .\scripts\switch-profile.ps1 -Profile clean
```

---

## Prompt Design

### Shark Theme (`shark.omp.json`)

A three-segment powerline prompt with transient mode:

| Segment | Content | Color |
|---|---|---|
| Left 1 | 🦈 + username | Pink `#FF79C6` |
| Left 2 | Path (agnoster, max 3 dirs, home icon) | Purple `#BD93F9` |
| Left 3 | Git branch + status | Pink / Red `#FF5555` if dirty |
| Right | Time (3:04 PM) | Purple |
| Transient | `🦈` on success · `💀` on error | — |

### Clean Theme (`clean.omp.json`)

Single segment — path only in cyan `#7FDBCA`. No decorations, no modules.

### Windows Terminal — Shark Dark Scheme

| Property | Value |
|---|---|
| Background | `#0B1220` (dark navy) |
| Foreground | `#F8F8F2` (off-white) |
| Cursor | `#FF79C6` (pink) |
| ANSI palette | Dracula-inspired |
| Font | CaskaydiaCove Nerd Font, 11pt |

Apply the fragment at `config/windows-terminal/settings-fragment.json` in Windows Terminal settings.

---

## Fish Plugins

Declared in `config/fish/plugins.txt` — installed automatically by Fisher during setup.

| Plugin | Purpose |
|---|---|
| `jorgebucaran/fisher` | Plugin manager |
| `PatrickF1/fzf.fish` | `Ctrl+F` file finder, `Ctrl+R` history, `Ctrl+Alt+F` directory |
| `jethrokuan/z` | Frecency-based directory jumping |
| `meaningful-ooo/sponge` | Remove failed commands from history |
| `franciscolourenco/done` | Desktop notification when long commands finish |
| `ilancosman/tide@v6` | Native fish prompt engine (tide profile fallback) |

---

## Aliases & Shortcuts

### Shared Aliases (fish + PowerShell)

| Alias | Expands To | Notes |
|---|---|---|
| `ll` | `eza -lh --git` | Long list with git status |
| `la` | `eza -lah --git` | Long list, show hidden |
| `ls` | `eza` | Color, icons |
| `cat` | `bat --style=plain` | Syntax-highlighted output |
| `..` | `cd ..` | Up one dir |
| `...` | `cd ../..` | Up two dirs |

### Git Shortcuts

| Alias | Command |
|---|---|
| `gs` | `git status -sb` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gpl` | `git pull --rebase` |
| `gd` | `git diff` |
| `gl` | `git log --oneline --graph` |

### FZF & Navigation

| Key | Action |
|---|---|
| `Ctrl+F` | Fuzzy file finder |
| `Ctrl+R` | Fuzzy history search |
| `Ctrl+Alt+F` | Directory finder (fish only) |
| `z <dir>` | Jump to frecent directory (zoxide) |
| `zi` | Interactive zoxide picker |

---

## PowerShell Module Stack

| Module / Tool | Purpose |
|---|---|
| `PSReadLine` | History prediction, ListView suggestions, 5000-entry history |
| `PSFzf` | Lazy-loaded on first `Ctrl+F`/`Ctrl+R` (saves ~400ms startup) |
| `oh-my-posh` | Shark powerline prompt |
| `zoxide` | Smart cd |
| `eza` + `bat` | Modern ls/cat replacements |

---

## Command Reference

### Linux / macOS

| Command | Description |
|---|---|
| `bash install.sh --full --profile shark` | Full install, shark profile |
| `bash install.sh --minimal --profile clean` | Minimal install, clean profile |
| `bash install.sh --dry-run --full --profile shark` | Preview — no changes |
| `bash scripts/verify.sh` | Post-install verification |
| `bash scripts/switch-profile.sh shark` | Activate shark profile |
| `bash scripts/switch-profile.sh clean` | Activate clean profile |
| `bash scripts/switch-profile.sh tide` | Activate tide profile |
| `bash update.sh` | Pull latest + redeploy config |
| `bash update.sh --no-pull` | Redeploy config without git pull |
| `bash uninstall.sh` | Remove config + restore latest backup |

### Windows (PowerShell)

| Command | Description |
|---|---|
| `pwsh -File .\install.ps1 -Full -SharkProfile shark` | Full install, shark profile |
| `pwsh -File .\install.ps1 -Minimal -SharkProfile clean` | Minimal install |
| `pwsh -File .\install.ps1 -DryRun -Full -SharkProfile shark` | Preview — no changes |
| `pwsh -File .\scripts\switch-profile.ps1 -Profile shark` | Activate shark profile |
| `pwsh -File .\scripts\switch-profile.ps1 -Profile clean` | Activate clean profile |

See full reference in `docs/COMMANDS.md`.

---

## Project Structure

```
SharkTerminal/
├── install.sh                      # Linux/macOS entry point
├── install.ps1                     # Windows/PowerShell entry point
├── uninstall.sh                    # Uninstall + restore from backup
├── update.sh                       # Config-only updater (safe for servers)
│
├── config/
│   ├── fish/
│   │   ├── config.fish             # Runtime config (sources env, aliases, profile)
│   │   ├── plugins.txt             # Fisher plugin manifest
│   │   ├── conf.d/
│   │   │   ├── aliases.fish        # eza/bat/git/nav aliases
│   │   │   └── env.fish            # EDITOR, PAGER, fzf backend, zoxide init
│   │   ├── functions/
│   │   │   └── fish_greeting.fish  # Kraken + FISHTERM ASCII greeting
│   │   ├── profiles/
│   │   │   ├── shark.fish          # Oh My Posh shark theme
│   │   │   ├── clean.fish          # Oh My Posh minimal theme
│   │   │   └── tide.fish           # Native Tide prompt
│   │   └── banner/
│   │       ├── kraken.txt          # Octopus ASCII art (Braille unicode)
│   │       └── fishterm.txt        # FISHTERM block-letter logo
│   │
│   ├── powershell/
│   │   ├── profile.ps1             # Entry point (dot-sourced from $PROFILE)
│   │   └── profiles/
│   │       ├── shark.ps1           # Full profile — OMP, PSReadLine, PSFzf, zoxide
│   │       └── clean.ps1           # Minimal profile
│   │
│   └── windows-terminal/
│       └── settings-fragment.json  # Shark Dark color scheme
│
├── themes/
│   ├── shark.omp.json              # Pink/purple powerline + transient prompt
│   └── clean.omp.json              # Minimal cyan theme
│
├── scripts/
│   ├── lib/
│   │   ├── log.sh                  # Logging helpers (info/warn/ok/die)
│   │   └── common.sh               # OS detection, prerequisite checks
│   ├── os/
│   │   ├── linux.sh                # apt / dnf / pacman dependency installer
│   │   ├── macos.sh                # Homebrew installer
│   │   └── windows.ps1             # winget + PS module installer
│   ├── install/
│   │   ├── fish.sh                 # Fish config deployer + Fisher bootstrap
│   │   ├── powershell.ps1          # PowerShell config deployer
│   │   ├── omp.sh                  # Oh My Posh installer
│   │   ├── fonts.sh                # Nerd Font installer
│   │   └── tools.sh                # Shared tooling layer
│   ├── switch-profile.sh           # Profile switcher (fish)
│   ├── switch-profile.ps1          # Profile switcher (PowerShell)
│   └── verify.sh                   # Post-install verification
│
└── docs/
    ├── COMMANDS.md                 # Full command reference
    └── TROUBLESHOOTING.md          # Common issues + fixes
```

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Icons show as boxes/squares | Install a [Nerd Font](https://www.nerdfonts.com/) and set it in your terminal |
| `oh-my-posh` not found | Run `bash scripts/verify.sh` — switch to tide: `bash scripts/switch-profile.sh tide` |
| Fish not auto-starting | Add `exec fish` to `~/.bashrc` or let the installer inject the handoff block |
| Fisher plugins fail to install | Check internet access; run `fisher update` inside fish |
| Missing tools (`eza`, `bat`, etc.) | Re-run `bash install.sh --full` or install the tool manually |
| PowerShell prompt blank | Confirm `oh-my-posh` is on PATH; run `oh-my-posh --version` in `pwsh` |
| PSFzf not working | Run `Get-Module PSFzf -ListAvailable`; install via `Install-Module PSFzf` |

**Full diagnostics:**
```bash
bash scripts/verify.sh
```

**Restore previous config:**
```bash
bash uninstall.sh   # removes current config, restores timestamped backup
```

---

## Safety & Backups

- **Dry run first:** `--dry-run` / `-DryRun` previews every action without touching your system.
- **Fish backup:** existing `~/.config/fish/` is copied to `~/.config/fish.backups/YYYYMMDD-HHMMSS/` before any changes.
- **PowerShell backup:** `$PROFILE` is backed up to `~/.config/sharkterminal/backups/powershell/` with a timestamp.
- **Idempotent injection:** the installer only appends a small sourcing block to `$PROFILE` — it checks for an existing block and skips if present.
- **Re-runnable:** installers are safe to run again on existing setups.
- **Shell handoff bypass:** set `SHARKTERMINAL_NO_HANDOFF=1` to prevent auto-entering fish from bash/zsh.

**Uninstall PowerShell integration:**
```powershell
# Remove the block between these markers in $PROFILE:
# >>> SharkTerminal PowerShell >>>  ...  # <<< SharkTerminal PowerShell <<<
# Then delete: ~/.config/sharkterminal/
```

---

## Notes

- First install requires internet access (package manager, Fisher, Oh My Posh)
- Some tool downloads fail in offline or blocked DNS environments — use `--minimal` for air-gapped machines
- On Debian/Ubuntu: `batcat` is symlinked to `bat`, `fdfind` to `fd` automatically
- On Arch: `eza` and `bat` are in the official repos
- macOS: Homebrew is required — install from [brew.sh](https://brew.sh)
- If `delta` fails on Linux, ensure `unzip` is installed: `apt install unzip`

---

## Author

**Nicholas Fisher**

[![GitHub](https://img.shields.io/badge/GitHub-NeptuneCipher42-181717?style=flat&logo=github&logoColor=white)](https://github.com/NeptuneCipher42)
