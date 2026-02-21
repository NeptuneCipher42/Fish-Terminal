#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Windows dependency installer using winget with graceful fallback when winget is unavailable.
#################################################################################################
param(
  [ValidateSet('minimal','full')]
  [string]$Mode = 'full',
  [switch]$DryRun
)

$basePackages = @(
  'Git.Git',
  'Fish.Fish',
  'junegunn.fzf',
  'ajeetdsouza.zoxide',
  'sharkdp.bat',
  'BurntSushi.ripgrep.MSVC',
  'sharkdp.fd',
  'tmux.tmux'
)

$fullPackages = @(
  'JanDeDobbeleer.OhMyPosh'
)

$packages = @($basePackages)
if ($Mode -eq 'full') {
  $packages += $fullPackages
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Warning 'winget not found; install dependencies manually.'
  return
}

if ($DryRun) {
  Write-Host "[DRY-RUN] winget packages: $($packages -join ', ')"
  return
}

foreach ($pkg in $packages) {
  winget install --id $pkg --accept-package-agreements --accept-source-agreements -e
}
