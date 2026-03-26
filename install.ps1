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

# ---------------------------------------------------------------------------
# Bootstrap — install PowerShell 7 if running in PS5, then re-launch
# ---------------------------------------------------------------------------
if ($PSVersionTable.PSVersion.Major -lt 7) {
  Write-Info "Running in PowerShell $($PSVersionTable.PSVersion) — PowerShell 7+ is recommended."

  if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    # PS7 is already installed — re-launch this script inside it
    Write-Info 'PowerShell 7 found. Re-launching installer in pwsh...'
    $forward = @('-ExecutionPolicy', 'Bypass', '-File', $MyInvocation.MyCommand.Path,
                 '-Profile', $Profile, "-$Mode")
    if ($DryRun) { $forward += '-DryRun' }
    & pwsh @forward
    exit $LASTEXITCODE
  }

  Write-Info 'PowerShell 7 not found — installing via winget...'
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install --id Microsoft.PowerShell --accept-package-agreements --accept-source-agreements -e
    Write-Host ''
    Write-Ok 'PowerShell 7 installed!'
    Write-Ok 'Close this window, open a new PowerShell terminal, and re-run:'
    Write-Host "  pwsh -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" -$Mode -Profile $Profile" -ForegroundColor Cyan
    exit 0
  } else {
    Write-Warning 'winget not available. Install PowerShell 7 manually from: https://aka.ms/PSWindows'
    Write-Info 'Continuing in PowerShell 5 — some features may behave differently.'
  }
}

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
& (Join-Path $Root 'scripts/install/powershell.ps1') -Profile $PSProfile -DryRun:$DryRun

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
