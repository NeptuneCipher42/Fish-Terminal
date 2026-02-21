#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# PowerShell installer entrypoint for Windows/WSL with mode/profile parsing and dry-run support.
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
if ($Full) { $Mode = 'full' }

Write-Host '[INFO] SharkTerminal installer (PowerShell)'
Write-Host "[INFO] Mode: $Mode"
Write-Host "[INFO] Profile: $Profile"
if ($DryRun) { Write-Host '[INFO] Dry run enabled' }

& "$Root/scripts/os/windows.ps1" -Mode $Mode -DryRun:$DryRun

if ($DryRun) {
  Write-Host '[DRY-RUN] Would run scripts/install/tools.sh'
  Write-Host '[DRY-RUN] Would run scripts/install/fish.sh'
  Write-Host '[DRY-RUN] Would run scripts/install/omp.sh'
  Write-Host '[DRY-RUN] Would run scripts/install/fonts.sh'
  Write-Host '[DRY-RUN] Would run scripts/verify.sh'
  exit 0
}

Write-Warning 'Windows full apply flow is scaffolded. Use dry-run in this environment.'
