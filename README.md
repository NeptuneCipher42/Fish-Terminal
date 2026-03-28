# SharkTerminal
<img width="854" height="389" alt="image" src="https://github.com/user-attachments/assets/941699db-36a0-4079-9c21-b0c28cbefae4" />

Fish-first terminal customization with shark vibes, Oh My Posh default, Tide fallback, plugin automation, cross-platform install scripts — and a massively upgraded **FishVim** Neovim config built for 2025/2026.

---

## Quick Start

### Linux/macOS
```bash
git clone https://github.com/NeptuneCipher42/Fish-Terminal.git SharkTerminal
cd SharkTerminal
bash install.sh --full --profile shark
```

> **Note:** Add `exec fish` to `.bashrc` or `.zshrc` to auto-start fish on terminal boot (or let the installer do it for you).

### Windows (PowerShell 7+)

**Step 1 — Install PowerShell 7**

Open Windows PowerShell (the built-in one) and run:
```powershell
winget search --id Microsoft.PowerShell
```
Then install the stable release:
```powershell
winget install --id Microsoft.PowerShell --source winget
```
Or install the preview if you want the latest features:
```powershell
winget install --id Microsoft.PowerShell.Preview --source winget
```
Close the window and reopen using **PowerShell 7** (`pwsh`) — not the old Windows PowerShell.

**Step 2 — Clone and install**
```powershell
git clone https://github.com/NeptuneCipher42/Fish-Terminal.git SharkTerminal
cd SharkTerminal
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -Full -SharkProfile shark
```

> **Nerd Font:** Install a [Nerd Font](https://www.nerdfonts.com/) (e.g. CaskaydiaCove NF) and set it as your terminal font for prompt icons to render correctly.

---

## What You Get

### Shell — PowerShell (Windows)
- Same **shark Oh My Posh theme** as the fish setup — `🦈 user › path › git branch › time` powerline prompt
- `PSReadLine` with history prediction and list-view suggestions
- `PSFzf` fuzzy finder — `Ctrl+F` for files, `Ctrl+R` for history
- `zoxide` smart `cd` with `z <dir>` shortcuts
- `posh-git` git status integration
- Modern CLI aliases: `ll`, `la`, `cat` (bat), `ls` (eza) — same shortcuts as fish
- Git shortcuts: `gs`, `ga`, `gc`, `gp`, `gpl`, `gl`
- Side-by-side ASCII art greeting on wide terminals (Cracken's Cavern banner)
- Profile switching: `shark` (full) and `clean` (minimal)
- Safe timestamped backup of existing `$PROFILE` before install

### Shell — Fish Terminal
- Shark-themed greeting with dual ASCII art banners (Kraken + FISHTERM logo)
- Oh My Posh default theme with Tide fallback profile
- Modern CLI replacements: `eza` (ls), `bat` (cat), `zoxide` (cd), `fd` (find), `ripgrep` (grep)
- Git shortcuts: `gs`, `ga`, `gc`, `gp`, `gpl`
- FZF fuzzy finder with fd backend (hidden files, .git excluded)
- Fisher plugins pre-configured (fzf.fish, z, sponge, done, tide)
- Profile switching between `shark`, `clean`, and `tide`
- Safe timestamped backups + full uninstall/restore

### FishVim — Neovim Config (2025 Edition)
A production-grade Neovim setup built from current best practices (r/neovim, LazyVim, kickstart.nvim, dotfyle.com rankings).

#### Plugin Highlights (70+ plugins)

| Category | Plugins |
|----------|---------|
| **Plugin Manager** | lazy.nvim (with startup profiler) |
| **Meta Plugin** | snacks.nvim (dashboard, notifier, indent, scroll, lazygit, zen, words, bigfile) |
| **Completion** | blink.cmp (replaced nvim-cmp — faster, typo-resistant, async) |
| **LSP** | nvim-lspconfig + mason.nvim + mason-lspconfig (15+ servers) |
| **Formatting** | conform.nvim (format on save, LSP fallback) |
| **Linting** | nvim-lint (eslint_d, ruff, shellcheck, luacheck, golangci-lint) |
| **Syntax** | nvim-treesitter + textobjects + context (30+ parsers) |
| **Fuzzy Finder** | Telescope + fzf-native sorter |
| **File Explorer** | nvim-tree (sidebar) + oil.nvim (edit filesystem as buffer) |
| **Git Inline** | gitsigns.nvim (hunk staging, blame, diff) |
| **Git Workflow** | neogit (Magit-style) + diffview.nvim + git-conflict.nvim |
| **AI Coding** | codecompanion.nvim (Claude/GPT/Ollama chat + inline diffs) |
| **Search/Replace** | grug-far.nvim (ripgrep-powered, LazyVim default) |
| **Markdown** | render-markdown.nvim (renders headings, code blocks, tables in-buffer) |
| **Code Outline** | aerial.nvim (LSP + treesitter symbol navigator) |
| **Navigation** | flash.nvim (jump anywhere) + harpoon2 (file bookmarks) |
| **Text Objects** | mini.ai (extended: functions, classes, args, quotes, buffer) |
| **Utilities** | mini.move, mini.splitjoin, mini.bufremove, mini.hipatterns |
| **Debugging** | nvim-dap + nvim-dap-ui + nvim-dap-virtual-text |
| **Testing** | neotest + Go/Python/Vitest adapters |
| **Statusline** | lualine.nvim (cyberpunk FishVim theme with LSP client, diff, clock) |
| **Bufferline** | bufferline.nvim |
| **UI** | noice.nvim (cmdline popup, LSP docs) + dressing.nvim |
| **Sessions** | auto-session |
| **Snippets** | LuaSnip + friendly-snippets |
| **Colorscheme** | Tokyo Night — heavily cyberpunk-customized (neon green, electric blue, magenta) |

#### Language Server Support (via Mason)
`lua` `typescript/javascript` `python` `go` `rust` `svelte` `graphql` `html` `css` `json` `yaml` `toml` `bash` `docker` `markdown` `terraform`

#### Keymaps — Space as Leader

| Keymap | Action |
|--------|--------|
| `<Space>ff` | Find files (Telescope) |
| `<Space>fs` | Live grep |
| `<Space>fr` | Recent files |
| `<Space>gg` | LazyGit (snacks float) |
| `<Space>gn` | Neogit (full git workflow) |
| `<Space>gd` | Diffview |
| `<Space>ee` | File explorer (nvim-tree) |
| `-` | Oil file browser (parent dir) |
| `<Space>lo` | Code outline (aerial) |
| `<Space>aa` | AI actions (CodeCompanion) |
| `<Space>ac` | AI chat toggle |
| `<Space>ai` | AI inline prompt |
| `<Space>sr` | Search & replace (grug-far) |
| `<Space>ld` | Line diagnostics |
| `<Space>lr` | Rename symbol |
| `<Space>la` | Code actions |
| `<Space>uz` | Zen mode |
| `<Space>ut` | Float terminal |
| `<Space>um` | Toggle markdown rendering |
| `s` | Flash jump |
| `S` | Flash treesitter jump |
| `<Space>ha` | Harpoon add file |
| `<Space>hh` | Harpoon menu |
| `]f` / `[f` | Next / prev function (treesitter) |
| `]d` / `[d` | Next / prev diagnostic |
| `]]` / `[[` | Next / prev word reference |

#### Neovim 0.11 Features Enabled
- `vim.treesitter.foldexpr()` — native treesitter-powered folding
- Inlay hints toggle (`<Space>uh`)
- Diagnostic virtual lines toggle (`<Space>uL`)
- Smooth scrolling (`smoothscroll = true`)
- Built-in Lua bytecode caching (impatient.nvim not needed)
- Disabled unused built-in plugins (gzip, matchit, netrw, tutor, etc.) for fast startup

#### AI Setup
Set one of these environment variables to enable AI features:
```bash
export ANTHROPIC_API_KEY="sk-ant-..."   # Claude (recommended — claude-sonnet-4-6)
export OPENAI_API_KEY="sk-..."          # GPT-4o
# GitHub Models (free): no key needed if GITHUB_TOKEN is set
```

---

## Profiles

| Profile | Fish | PowerShell | Description |
|---------|------|------------|-------------|
| `shark` | ✅ | ✅ | Full shark aesthetic — Oh My Posh + Nerd Font icons + ASCII greeting |
| `clean` | ✅ | ✅ | Minimal Oh My Posh theme, lean visuals |
| `tide`  | ✅ | ➡️ shark | Native fish Tide engine (PS falls back to shark) |

Switch profiles — fish:
```bash
bash scripts/switch-profile.sh shark
bash scripts/switch-profile.sh clean
bash scripts/switch-profile.sh tide
```

Switch profiles — PowerShell:
```powershell
pwsh -File .\scripts\switch-profile.ps1 -Profile shark
pwsh -File .\scripts\switch-profile.ps1 -Profile clean
```

---

## Fish Plugins
Defined in `config/fish/plugins.txt`:
- `jorgebucaran/fisher` — plugin manager
- `PatrickF1/fzf.fish` — fzf integration
- `jethrokuan/z` — directory jumping
- `meaningful-ooo/sponge` — smart history cleanup
- `franciscolourenco/done` — command completion notifications
- `ilancosman/tide` — fallback prompt engine

---

## Main Commands

### Linux/macOS (bash)

| Command | Description |
|---------|-------------|
| `bash install.sh --full --profile shark` | Full install with shark profile |
| `bash install.sh --minimal --profile clean` | Minimal install |
| `bash install.sh --dry-run --full --profile shark` | Preview without executing |
| `bash scripts/verify.sh` | Verify installation |
| `bash scripts/switch-profile.sh shark` | Switch to shark profile |
| `bash uninstall.sh` | Uninstall and restore backups |

### Windows (PowerShell)

| Command | Description |
|---------|-------------|
| `pwsh -File .\install.ps1 -Full -SharkProfile shark` | Full install with shark profile |
| `pwsh -File .\install.ps1 -Minimal -SharkProfile clean` | Minimal install |
| `pwsh -File .\install.ps1 -DryRun -Full -SharkProfile shark` | Preview without executing |
| `pwsh -File .\scripts\switch-profile.ps1 -Profile shark` | Switch to shark profile |
| `pwsh -File .\scripts\switch-profile.ps1 -Profile clean` | Switch to clean profile |

See full command list in `docs/COMMANDS.md`.

---

## Project Structure
```
SharkTerminal/
├── install.sh              # Linux/macOS entry point
├── install.ps1             # Windows/PowerShell entry point
├── uninstall.sh            # Uninstall + restore (Linux/macOS)
├── update.sh               # Config-only updater (Linux/macOS)
├── config/
│   ├── fish/               # Fish shell config, profiles, plugins, banners
│   └── powershell/         # PowerShell profiles (shark, clean)
├── scripts/
│   ├── os/                 # OS-specific dependency installers
│   ├── install/            # Config + prompt install internals
│   │   ├── fish.sh         # Fish config deployer
│   │   ├── powershell.ps1  # PowerShell config deployer
│   │   ├── omp.sh          # Oh My Posh installer (Linux/macOS)
│   │   ├── tools.sh        # CLI tools installer (Linux/macOS)
│   │   └── fonts.sh        # Nerd Fonts installer
│   ├── switch-profile.sh   # Profile switcher (bash)
│   └── switch-profile.ps1  # Profile switcher (PowerShell — fish + PS)
├── themes/                 # Oh My Posh JSON themes (shared by fish + PS)
└── docs/                   # Commands + troubleshooting
```

FishVim Neovim config lives in `~/.config/nvim/lua/fisher/`:
```
lua/fisher/
├── core/
│   ├── options.lua         # Neovim options (0.11 features enabled)
│   └── keymaps.lua         # Global keymaps (Space leader)
├── lazy.lua                # lazy.nvim bootstrap + perf opts
└── plugins/
    ├── snacks.lua           # Meta-plugin: dashboard, notifier, indent, lazygit...
    ├── cmp.lua              # blink.cmp completion
    ├── treesitter.lua       # Syntax + textobjects + context
    ├── oil.lua              # Filesystem-as-buffer editor
    ├── neogit.lua           # Neogit + diffview + git-conflict
    ├── ai.lua               # CodeCompanion AI assistant
    ├── aerial.lua           # Code outline
    ├── grug-far.lua         # Search & replace
    ├── render-markdown.lua  # In-buffer markdown rendering
    ├── mini.lua             # mini.ai, mini.move, mini.splitjoin, mini.hipatterns
    ├── lsp/
    │   ├── mason.lua        # Mason installer (15+ servers)
    │   └── config.lua       # LSP setup + LspAttach keymaps
    └── ...30+ more plugins
```

---

## Notes

### Safety
- **Dry run first:** `--dry-run` / `-DryRun` shows every action without making changes.
- **Existing `$PROFILE` is backed up** to `~/.config/sharkterminal/backups/powershell/` before install.
- **Idempotent injection:** the PowerShell installer only appends a small sourcing block to `$PROFILE` — it never overwrites it. If the block is already there, it's skipped.
- **Existing fish config backed up** to `~/.config/fish.backups/` with timestamps.
- Re-runnable installers — safe to run again on existing setups.

### PowerShell
- Deployed config lives in `~/.config/sharkterminal/powershell/` — separate from `$PROFILE`.
- To uninstall PS integration: remove the `# >>> SharkTerminal PowerShell >>>` block from `$PROFILE` and delete `~/.config/sharkterminal/`.
- If OMP fails to render icons, set a [Nerd Font](https://www.nerdfonts.com/) in your terminal emulator settings.

### Fish (Linux/macOS)
- If OMP fails, switch to `tide` profile: `bash scripts/switch-profile.sh tide`
- Fish handoff block added to `~/.bashrc` / `~/.zshrc` automatically.
- Bypass fish handoff: `export SHARKTERMINAL_NO_HANDOFF=1`

### Neovim
- Startup time: `nvim --startuptime /tmp/startup.log` → analyze with `:Lazy profile`
