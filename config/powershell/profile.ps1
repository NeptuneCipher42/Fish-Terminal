#################################################################################################
# Author: Nicholas Fisher
# Date: March 25th 2026
# Description of Script
# SharkTerminal PowerShell profile entry point — dot-sourced from $PROFILE on install.
# Loads the active profile from the SharkTerminal install directory.
#################################################################################################
$global:SHARKTERMINAL_ROOT = Join-Path $HOME '.config/sharkterminal'
$STRoot = $global:SHARKTERMINAL_ROOT

$ActiveProfile = Join-Path $STRoot 'powershell/active-profile.ps1'

if (Test-Path $ActiveProfile) {
  . $ActiveProfile
} else {
  Write-Host '[SharkTerminal] No active PowerShell profile found. Run install.ps1 to configure.' -ForegroundColor Yellow
}
