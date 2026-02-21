#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# PowerShell profile switch helper that activates shark, clean, or tide fish profile files.
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
$FishConfig = Join-Path $HOME '.config/fish'
$Profiles = Join-Path $FishConfig 'profiles'
$ConfD = Join-Path $FishConfig 'conf.d'

New-Item -ItemType Directory -Force -Path $Profiles | Out-Null
New-Item -ItemType Directory -Force -Path $ConfD | Out-Null

Copy-Item (Join-Path $Root "config/fish/profiles/$Profile.fish") (Join-Path $Profiles "$Profile.fish") -Force
Copy-Item (Join-Path $Profiles "$Profile.fish") (Join-Path $ConfD 'active-profile.fish') -Force

Write-Host "Switched profile to: $Profile"
