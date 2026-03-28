#################################################################################################
# Author: Nicholas Fisher
# Date: March 25th 2026
# Description of Script
# PowerShell config deployment stage — backs up existing $PROFILE, copies SharkTerminal
# PS configs to ~/.config/sharkterminal/powershell/, and wires up $PROFILE.
#################################################################################################
param(
  [ValidateSet('shark','clean')]
  [string]$SharkProfile = 'shark',
  [switch]$DryRun
)

$Root       = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$InstallDir = Join-Path $HOME '.config/sharkterminal'
$PSInstall  = Join-Path $InstallDir 'powershell'
$ThemeDir   = Join-Path $InstallDir 'themes'
$BannerDir  = Join-Path $InstallDir 'banner'
# Resolve $PROFILE — param is named $SharkProfile (not $Profile) so $PROFILE is never shadowed
$PSProfilePath = $PROFILE
if ([string]::IsNullOrEmpty($PSProfilePath)) {
  $PSProfilePath = Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
}

function Write-Info ($msg) { Write-Host "[INFO] $msg" }
function Write-Ok   ($msg) { Write-Host "[ OK ] $msg" -ForegroundColor Green }
function Write-Warn ($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }

if ($DryRun) {
  Write-Info "DRY-RUN: Would deploy PowerShell config to $PSInstall"
  Write-Info "DRY-RUN: Would set active profile to $SharkProfile"
  Write-Info "DRY-RUN: Would write `$PROFILE at $PSProfilePath"
  return
}

# ---------------------------------------------------------------------------
# Create install directories
# ---------------------------------------------------------------------------
foreach ($dir in @($PSInstall, "$PSInstall/profiles", $ThemeDir, $BannerDir)) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

# ---------------------------------------------------------------------------
# Backup existing $PROFILE
# ---------------------------------------------------------------------------
if (Test-Path $PSProfilePath) {
  $BackupDir = Join-Path $InstallDir 'backups/powershell'
  New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
  $Stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'
  $Target = Join-Path $BackupDir "profile_$Stamp.ps1"
  Copy-Item $PSProfilePath $Target -Force
  Write-Ok "Backed up existing PowerShell profile to $Target"
}

# ---------------------------------------------------------------------------
# Deploy config files
# ---------------------------------------------------------------------------
Copy-Item (Join-Path $Root 'config/powershell/profile.ps1')                    (Join-Path $PSInstall 'profile.ps1') -Force
Copy-Item (Join-Path $Root "config/powershell/profiles/$SharkProfile.ps1")     (Join-Path $PSInstall "profiles/$SharkProfile.ps1") -Force
Copy-Item (Join-Path $Root 'config/powershell/profiles/shark.ps1')             (Join-Path $PSInstall 'profiles/shark.ps1') -Force
Copy-Item (Join-Path $Root 'config/powershell/profiles/clean.ps1')             (Join-Path $PSInstall 'profiles/clean.ps1') -Force

# Deploy themes and banners (shared with fish)
Get-ChildItem (Join-Path $Root 'themes') -Filter '*.omp.json' |
  ForEach-Object { Copy-Item $_.FullName $ThemeDir -Force }
Get-ChildItem (Join-Path $Root 'config/fish/banner') -Filter '*.txt' |
  ForEach-Object { Copy-Item $_.FullName $BannerDir -Force }

# Set active profile
Copy-Item (Join-Path $PSInstall "profiles/$SharkProfile.ps1") (Join-Path $PSInstall 'active-profile.ps1') -Force
Write-Ok "Active PowerShell profile set to: $SharkProfile"

# ---------------------------------------------------------------------------
# Wire up $PROFILE to dot-source from install directory
# ---------------------------------------------------------------------------
$ProfileDir = Split-Path -Parent $PSProfilePath
if (-not (Test-Path $ProfileDir)) {
  New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
}

$SourceLine = ". `"$(Join-Path $PSInstall 'profile.ps1')`""

# Only inject once — idempotent
if (Test-Path $PSProfilePath) {
  $Existing = Get-Content $PSProfilePath -Raw
} else {
  $Existing = ''
}

if ($Existing -notmatch 'sharkterminal') {
  $Header = '# >>> SharkTerminal PowerShell >>>'
  $Footer = '# <<< SharkTerminal PowerShell <<<'
  Add-Content $PSProfilePath ''
  Add-Content $PSProfilePath $Header
  Add-Content $PSProfilePath $SourceLine
  Add-Content $PSProfilePath $Footer
  Write-Ok "Injected SharkTerminal into: $PSProfilePath"
} else {
  Write-Info "SharkTerminal block already present in `$PROFILE — skipping injection."
}

# ---------------------------------------------------------------------------
# Install PowerShell modules
# ---------------------------------------------------------------------------
# Trust PSGallery silently so Install-Module never prompts interactively
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue

$Modules = @('PSReadLine', 'PSFzf', 'posh-git')
foreach ($mod in $Modules) {
  if (-not (Get-Module -ListAvailable -Name $mod -ErrorAction SilentlyContinue)) {
    Write-Info "Installing PS module: $mod"
    try {
      Install-Module -Name $mod -Repository PSGallery -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
      Write-Ok "Installed: $mod"
    } catch {
      Write-Warn "Could not install $mod — install manually: Install-Module $mod"
    }
  } else {
    Write-Info "Module already installed: $mod"
  }
}

Write-Ok "PowerShell configuration deployed ($SharkProfile). Restart PowerShell to apply."
