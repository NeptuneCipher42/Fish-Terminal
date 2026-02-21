# SharkTerminal Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a cross-platform, fish-first terminal customization repo with shark-themed prompt, one-command installers, profile switching, and complete docs.

**Architecture:** Use a thin top-level installer (`install.sh`/`install.ps1`) that delegates to OS-specific scripts and shared config payloads. Keep all fish behavior in template files under `config/fish` and switch prompt profiles via generated include files so installs remain idempotent and reversible.

**Tech Stack:** Bash, PowerShell, Fish shell, fisher plugins, Oh My Posh, Tide fallback.

---

### Task 1: Bootstrap Repository Skeleton

**Files:**
- Create: `.gitignore`
- Create: `LICENSE`
- Create: `scripts/lib/common.sh`
- Create: `scripts/lib/log.sh`

**Step 1: Create ignore rules**
Add `.gitignore` for backups, temp files, logs, and local test artifacts.

**Step 2: Add permissive license**
Create `LICENSE` (MIT).

**Step 3: Add shared logging helpers**
Create `scripts/lib/log.sh` with `info`, `warn`, `error`, `ok`, `die` helpers.

**Step 4: Add shared shell guards**
Create `scripts/lib/common.sh` with strict mode setup, OS detection, and helper checks.

**Step 5: Commit**
Run:
```bash
git add .gitignore LICENSE scripts/lib/common.sh scripts/lib/log.sh
git commit -m "chore: scaffold repository and shared script libraries"
```

### Task 2: Implement Linux/macOS Installer Entrypoint

**Files:**
- Create: `install.sh`
- Create: `scripts/os/linux.sh`
- Create: `scripts/os/macos.sh`

**Step 1: Write failing smoke command**
Run `bash install.sh --dry-run` and confirm command fails before file exists.

**Step 2: Implement install CLI parser**
Add `install.sh` supporting flags `--minimal`, `--full`, `--dry-run`, `--profile`.

**Step 3: Implement Linux package install script**
Create `scripts/os/linux.sh` with package manager detection and package sets.

**Step 4: Implement macOS package install script**
Create `scripts/os/macos.sh` using `brew` with package list parity.

**Step 5: Verify entrypoint behavior**
Run:
```bash
bash install.sh --dry-run
```
Expected: prints detected OS, selected mode, and planned install actions.

**Step 6: Commit**
```bash
git add install.sh scripts/os/linux.sh scripts/os/macos.sh
git commit -m "feat: add unix installer entrypoint and os package installers"
```

### Task 3: Implement Windows Installer Entrypoint

**Files:**
- Create: `install.ps1`
- Create: `scripts/os/windows.ps1`

**Step 1: Implement PowerShell CLI flags**
Support `-Minimal`, `-Full`, `-DryRun`, `-Profile`.

**Step 2: Implement package install flow**
Use `winget` best-effort installs and clear warnings when unavailable.

**Step 3: Verify parser and dry-run output**
Run:
```bash
pwsh -File ./install.ps1 -DryRun
```
Expected: prints action plan and no side effects.

**Step 4: Commit**
```bash
git add install.ps1 scripts/os/windows.ps1
git commit -m "feat: add windows installer entrypoint and package installer"
```

### Task 4: Add Fish Config, Prompt Profiles, and Plugins

**Files:**
- Create: `config/fish/config.fish`
- Create: `config/fish/conf.d/aliases.fish`
- Create: `config/fish/conf.d/env.fish`
- Create: `config/fish/functions/fish_greeting.fish`
- Create: `config/fish/profiles/shark.fish`
- Create: `config/fish/profiles/clean.fish`
- Create: `config/fish/profiles/tide.fish`
- Create: `config/fish/plugins.txt`

**Step 1: Define shared fish config bootstrap**
Create `config.fish` that sources env/aliases and active profile include.

**Step 2: Define alias/env defaults**
Set QoL aliases and safe env defaults with checks for installed binaries.

**Step 3: Add shark greeting and profile files**
Provide shark-style greeting and prompt init per profile.

**Step 4: Add plugin manifest**
Include fisher plugin list in `plugins.txt`.

**Step 5: Commit**
```bash
git add config/fish
git commit -m "feat: add fish configs, profiles, and plugin manifest"
```

### Task 5: Add Theme Assets and Profile Switcher

**Files:**
- Create: `themes/shark.omp.json`
- Create: `themes/clean.omp.json`
- Create: `scripts/switch-profile.sh`
- Create: `scripts/switch-profile.ps1`

**Step 1: Add Oh My Posh theme files**
Create shark and clean prompt definitions.

**Step 2: Implement profile switch script (bash)**
Script sets active fish profile include and validates profile exists.

**Step 3: Implement profile switch script (PowerShell)**
Equivalent switching for Windows.

**Step 4: Verify switching**
Run:
```bash
bash scripts/switch-profile.sh shark
bash scripts/switch-profile.sh clean
bash scripts/switch-profile.sh tide
```
Expected: active profile file changes with no errors.

**Step 5: Commit**
```bash
git add themes scripts/switch-profile.sh scripts/switch-profile.ps1
git commit -m "feat: add prompt themes and profile switching commands"
```

### Task 6: Add Install Internals, Backups, and Uninstall

**Files:**
- Create: `scripts/install/fish.sh`
- Create: `scripts/install/omp.sh`
- Create: `scripts/install/fonts.sh`
- Create: `scripts/install/tools.sh`
- Create: `scripts/verify.sh`
- Create: `uninstall.sh`

**Step 1: Add backup and deploy behavior**
Copy existing fish config to timestamped backup before writing new files.

**Step 2: Add fisher + plugins install logic**
Install fisher and plugins from manifest idempotently.

**Step 3: Add OMP and font installers**
Install Oh My Posh and Nerd Font with fallback warnings.

**Step 4: Add verification script**
Check binaries, fish config parse, plugin presence, theme/profile existence.

**Step 5: Add uninstall + restore**
Remove managed files and restore latest backup when available.

**Step 6: Verify scripts are executable and syntactically valid**
Run:
```bash
bash -n install.sh scripts/os/linux.sh scripts/os/macos.sh scripts/lib/common.sh scripts/lib/log.sh scripts/switch-profile.sh scripts/install/fish.sh scripts/install/omp.sh scripts/install/fonts.sh scripts/install/tools.sh scripts/verify.sh uninstall.sh
```
Expected: no syntax errors.

**Step 7: Commit**
```bash
git add scripts/install scripts/verify.sh uninstall.sh
git commit -m "feat: add installers, verification, backups, and uninstall"
```

### Task 7: Documentation and Usage Guides

**Files:**
- Create: `docs/COMMANDS.md`
- Create: `docs/TROUBLESHOOTING.md`
- Modify: `README.md`

**Step 1: Write command reference**
Document install, switch, verify, and uninstall commands for Linux/macOS/Windows.

**Step 2: Write troubleshooting guide**
Cover common failures: missing font glyphs, OMP not found, fish not default shell, plugin install errors.

**Step 3: Rewrite README for first-run setup**
Put quick start at top, then features, profiles, plugin list, customization, and maintenance.

**Step 4: Verify docs references**
Run:
```bash
rg -n "TODO|TBD|PLACEHOLDER" README.md docs/COMMANDS.md docs/TROUBLESHOOTING.md
```
Expected: no matches.

**Step 5: Commit**
```bash
git add README.md docs/COMMANDS.md docs/TROUBLESHOOTING.md
git commit -m "docs: add complete setup, commands, and troubleshooting guides"
```

### Task 8: Final Validation Pass

**Files:**
- Modify: `README.md` (if needed for corrections)

**Step 1: Run repository verification suite**
Run:
```bash
bash scripts/verify.sh || true
```
Expected: prints checks and actionable warnings in this environment.

**Step 2: Run dry-run installers**
Run:
```bash
bash install.sh --dry-run --full --profile shark
bash install.sh --dry-run --minimal --profile clean
```
Expected: both commands complete and show deterministic plans.

**Step 3: Optional local apply test**
Run:
```bash
bash install.sh --full --profile shark
```
Expected: fish config installed and profile active.

**Step 4: Commit final touch-ups**
```bash
git add README.md scripts/verify.sh install.sh
git commit -m "chore: finalize validation and polish installer output"
```
