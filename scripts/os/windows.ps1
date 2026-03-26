#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Windows dependency installer — installs CLI tools via winget and PowerShell modules
# via Install-Module. Gracefully skips unavailable tools.
#################################################################################################
param(
  [ValidateSet('minimal','full')]
  [string]$Mode = 'full',
  [switch]$DryRun
)

# ---------------------------------------------------------------------------
# winget packages
# ---------------------------------------------------------------------------
$basePackages = @(
  'Git.Git',
  'Fish.Fish',
  'junegunn.fzf',
  'ajeetdsouza.zoxide',
  'sharkdp.bat',
  'BurntSushi.ripgrep.MSVC',
  'sharkdp.fd',
  'eza-community.eza'
)

$fullPackages = @(
  'JanDeDobbeleer.OhMyPosh',
  'Neovim.Neovim'
)

$packages = @($basePackages)
if ($Mode -eq 'full') { $packages += $fullPackages }

# ---------------------------------------------------------------------------
# PowerShell modules
# ---------------------------------------------------------------------------
$psModules = @('PSReadLine', 'PSFzf', 'posh-git')

if ($DryRun) {
  Write-Host "[DRY-RUN] winget packages : $($packages -join ', ')"
  Write-Host "[DRY-RUN] PS modules      : $($psModules -join ', ')"
  return
}

# winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Warning 'winget not found. Install the App Installer from the Microsoft Store, then re-run.'
} else {
  foreach ($pkg in $packages) {
    Write-Host "[INFO] winget install $pkg"
    winget install --id $pkg --source winget --accept-package-agreements --accept-source-agreements --disable-interactivity -e
  }
}

# PS modules — trust PSGallery first to suppress interactive prompts
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue

foreach ($mod in $psModules) {
  if (-not (Get-Module -ListAvailable -Name $mod -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Installing PS module: $mod"
    try {
      Install-Module -Name $mod -Repository PSGallery -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
      Write-Host "[ OK ] Installed: $mod" -ForegroundColor Green
    } catch {
      Write-Warning "Could not install $mod — install manually: Install-Module $mod"
    }
  } else {
    Write-Host "[INFO] Module already installed: $mod"
  }
}
