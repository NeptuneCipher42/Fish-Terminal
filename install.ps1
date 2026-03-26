#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# PowerShell installer entrypoint for Windows — installs dependencies via winget, deploys
# Oh My Posh themes to PowerShell $PROFILE, and optionally deploys fish config for WSL/Git Bash.
#################################################################################################
param(
  [switch]$Minimal,
  [switch]$Full,
  [switch]$DryRun,
  [ValidateSet('shark','clean','tide')]
  [string]$Profile = 'shark'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

$Mode = 'full'
if ($Minimal) { $Mode = 'minimal' }
if ($Full)    { $Mode = 'full' }

function Write-Info ($msg) { Write-Host "[INFO] $msg" }
function Write-Ok   ($msg) { Write-Host "[ OK ] $msg" -ForegroundColor Green }

Write-Info 'SharkTerminal installer (PowerShell)'
Write-Info "Mode    : $Mode"
Write-Info "Profile : $Profile"
if ($DryRun) { Write-Info 'Dry run enabled — no changes will be made.' }

# ---------------------------------------------------------------------------
# Stage 1 — Install dependencies via winget
# ---------------------------------------------------------------------------
Write-Info 'Stage 1: Installing system dependencies...'
& (Join-Path $Root 'scripts/os/windows.ps1') -Mode $Mode -DryRun:$DryRun

# ---------------------------------------------------------------------------
# Stage 2 — Deploy PowerShell config + Oh My Posh themes
# ---------------------------------------------------------------------------
Write-Info 'Stage 2: Deploying PowerShell configuration...'
$PSProfile = if ($Profile -eq 'tide') { 'shark' } else { $Profile }  # tide is fish-only; PS uses shark fallback
& (Join-Path $Root 'scripts/install/powershell.ps1') -SharkProfile $PSProfile -DryRun:$DryRun

# ---------------------------------------------------------------------------
# Stage 3 — Deploy fish config (if fish is available — WSL/Git Bash)
# ---------------------------------------------------------------------------
if (Get-Command fish -ErrorAction SilentlyContinue) {
  Write-Info 'Stage 3: Fish shell detected — deploying fish configuration...'
  if ($DryRun) {
    Write-Info 'DRY-RUN: Would run scripts/install/fish.sh'
  } else {
    bash (Join-Path $Root 'scripts/install/fish.sh') $Profile
  }
} else {
  Write-Info 'Stage 3: Fish not found — skipping fish config (Windows-native PowerShell install).'
}

if ($DryRun) {
  Write-Info 'Dry run complete. No changes were made.'
  exit 0
}

Write-Ok 'SharkTerminal installation complete!'
Write-Ok 'Restart PowerShell (or open a new terminal) to apply the new profile.'
Write-Ok "To switch profiles later: pwsh -File .\scripts\switch-profile.ps1 -Profile shark"
