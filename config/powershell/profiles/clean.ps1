#################################################################################################
# Author: Nicholas Fisher
# Date: March 25th 2026
# Description of Script
# SharkTerminal PowerShell clean profile — minimal Oh My Posh theme, essential aliases,
# zoxide, and PSReadLine. No ASCII art greeting.
#################################################################################################
$STRoot = if ($global:SHARKTERMINAL_ROOT) { $global:SHARKTERMINAL_ROOT } else { Join-Path $HOME '.config/sharkterminal' }

# ---------------------------------------------------------------------------
# Oh My Posh — clean theme
# ---------------------------------------------------------------------------
$OmpTheme = Join-Path $STRoot 'themes/clean.omp.json'
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
  oh-my-posh init pwsh --config $OmpTheme | Invoke-Expression
}

# ---------------------------------------------------------------------------
# PSReadLine — history prediction
# ---------------------------------------------------------------------------
if (Get-Module -ListAvailable -Name PSReadLine -ErrorAction SilentlyContinue) {
  Import-Module PSReadLine
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# ---------------------------------------------------------------------------
# zoxide — smarter cd
# ---------------------------------------------------------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ---------------------------------------------------------------------------
# Core aliases
# ---------------------------------------------------------------------------
if (Get-Command eza -ErrorAction SilentlyContinue) {
  function ls { eza @args }
  function ll { eza -lh --git @args }
  function la { eza -lah --git @args }
}

if (Get-Command bat -ErrorAction SilentlyContinue) {
  function cat { bat --style=plain @args }
}

function gs  { git status @args }
function ga  { git add @args }
function gc  { git commit @args }
function gp  { git push @args }
function gpl { git pull --rebase @args }

function ..  { Set-Location .. }
function ... { Set-Location ../.. }
