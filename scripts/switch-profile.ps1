#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Profile switch helper — activates shark, clean, or tide for PowerShell (Oh My Posh)
# and for fish shell if available.
#################################################################################################
param(
  [ValidateSet('shark','clean','tide')]
  [string]$Profile
)

if (-not $Profile) {
  Write-Host 'Usage: ./scripts/switch-profile.ps1 -Profile shark|clean|tide'
  exit 1
}

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

# ---------------------------------------------------------------------------
# PowerShell profile switch
# ---------------------------------------------------------------------------
$STRoot    = Join-Path $HOME '.config/sharkterminal'
$PSInstall = Join-Path $STRoot 'powershell'

if (Test-Path $PSInstall) {
  # tide is fish-only; PowerShell falls back to shark
  $PSProfile = if ($Profile -eq 'tide') { 'shark' } else { $Profile }
  $Src = Join-Path $PSInstall "profiles/$PSProfile.ps1"
  if (Test-Path $Src) {
    Copy-Item $Src (Join-Path $PSInstall 'active-profile.ps1') -Force
    Write-Host "[ OK ] PowerShell profile switched to: $PSProfile" -ForegroundColor Green
    if ($Profile -eq 'tide') {
      Write-Host '[INFO] tide is fish-only — PowerShell will use the shark profile.' -ForegroundColor Yellow
    }
  } else {
    Write-Warning "PowerShell profile not found: $Src — run install.ps1 first."
  }
} else {
  Write-Host '[INFO] SharkTerminal PowerShell config not installed yet. Run install.ps1 to set up.' -ForegroundColor Yellow
}

# ---------------------------------------------------------------------------
# Fish shell profile switch (WSL / Git Bash / native fish on Windows)
# ---------------------------------------------------------------------------
$FishConfig = Join-Path $HOME '.config/fish'
$Profiles   = Join-Path $FishConfig 'profiles'
$ConfD      = Join-Path $FishConfig 'conf.d'

if (Test-Path $FishConfig) {
  New-Item -ItemType Directory -Force -Path $Profiles | Out-Null
  New-Item -ItemType Directory -Force -Path $ConfD    | Out-Null

  $FishSrc = Join-Path $Root "config/fish/profiles/$Profile.fish"
  if (Test-Path $FishSrc) {
    Copy-Item $FishSrc (Join-Path $Profiles "$Profile.fish") -Force
    Copy-Item (Join-Path $Profiles "$Profile.fish") (Join-Path $ConfD 'active-profile.fish') -Force
    Write-Host "[ OK ] Fish profile switched to: $Profile" -ForegroundColor Green
  } else {
    Write-Warning "Fish profile not found: $FishSrc"
  }
} else {
  Write-Host '[INFO] Fish config directory not found — skipping fish profile switch.' -ForegroundColor Yellow
}

Write-Host "Profile switch complete: $Profile (restart your shell to apply)"
