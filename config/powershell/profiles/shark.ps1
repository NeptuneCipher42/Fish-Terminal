#################################################################################################
# Author: Nicholas Fisher
# Date: March 25th 2026
# Description of Script
# SharkTerminal PowerShell shark profile — Oh My Posh shark theme, modern CLI aliases,
# zoxide, PSFzf, PSReadLine enhancements, and ASCII art greeting.
#################################################################################################
$STRoot = if ($global:SHARKTERMINAL_ROOT) { $global:SHARKTERMINAL_ROOT } else { Join-Path $HOME '.config/sharkterminal' }

# ---------------------------------------------------------------------------
# Oh My Posh — shark theme
# ---------------------------------------------------------------------------
$OmpTheme = Join-Path $STRoot 'themes/shark.omp.json'
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
  oh-my-posh init pwsh --config $OmpTheme | Invoke-Expression
} else {
  Write-Host '[SharkTerminal] oh-my-posh not found. Install via: winget install JanDeDobbeleer.OhMyPosh' -ForegroundColor Yellow
}

# ---------------------------------------------------------------------------
# PSReadLine — history prediction and better key bindings
# ---------------------------------------------------------------------------
if (Get-Module -ListAvailable -Name PSReadLine -ErrorAction SilentlyContinue) {
  Import-Module PSReadLine
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# ---------------------------------------------------------------------------
# PSFzf — fuzzy finder (Ctrl+F for files, Ctrl+R for history)
# ---------------------------------------------------------------------------
if (Get-Module -ListAvailable -Name PSFzf -ErrorAction SilentlyContinue) {
  Import-Module PSFzf
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ---------------------------------------------------------------------------
# zoxide — smarter cd
# ---------------------------------------------------------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ---------------------------------------------------------------------------
# posh-git — git status in prompt (used alongside Oh My Posh)
# ---------------------------------------------------------------------------
if (Get-Module -ListAvailable -Name posh-git -ErrorAction SilentlyContinue) {
  Import-Module posh-git
}

# ---------------------------------------------------------------------------
# Modern CLI aliases (mirrors fish aliases.fish)
# ---------------------------------------------------------------------------
if (Get-Command eza -ErrorAction SilentlyContinue) {
  function ls  { eza @args }
  function ll  { eza -lh --git @args }
  function la  { eza -lah --git @args }
  function lt  { eza --tree --level=2 @args }
} else {
  function ll  { Get-ChildItem @args }
  function la  { Get-ChildItem -Force @args }
}

if (Get-Command bat -ErrorAction SilentlyContinue) {
  function cat { bat --style=plain @args }
}

# Git shortcuts
function gs  { git status @args }
function ga  { git add @args }
function gc  { git commit @args }
function gp  { git push @args }
function gpl { git pull --rebase @args }
function gd  { git diff @args }
function gl  { git log --oneline --graph --decorate @args }

# Navigation
function ..  { Set-Location .. }
function ... { Set-Location ../.. }

# ---------------------------------------------------------------------------
# Greeting — mirrors fish_greeting.fish (side-by-side on wide terminals)
# ---------------------------------------------------------------------------
$KrakenBanner  = Join-Path $STRoot 'banner/kraken.txt'
$FishtermBanner = Join-Path $STRoot 'banner/fishterm.txt'

Write-Host ''
Write-Host '🐙  Cracken''s Cavern  🐙' -ForegroundColor Magenta
Write-Host ''

if ((Test-Path $KrakenBanner) -and (Test-Path $FishtermBanner)) {
  try { $TermWidth = $Host.UI.RawUI.WindowSize.Width } catch { $TermWidth = 80 }
  if ($TermWidth -lt 1) { $TermWidth = 80 }

  $LeftLines  = Get-Content $KrakenBanner
  $RightLines = Get-Content $FishtermBanner
  $MaxLines   = [Math]::Max($LeftLines.Count, $RightLines.Count)

  if ($TermWidth -ge 76) {
    for ($i = 0; $i -lt $MaxLines; $i++) {
      $Left  = if ($i -lt $LeftLines.Count)  { $LeftLines[$i] }  else { '' }
      $Right = if ($i -lt $RightLines.Count) { $RightLines[$i] } else { '' }
      if ($Right) {
        Write-Host ('{0,-30}' -f $Left) -ForegroundColor Magenta -NoNewline
        Write-Host "  $Right" -ForegroundColor DarkMagenta
      } else {
        Write-Host $Left -ForegroundColor Magenta
      }
    }
  } else {
    $LeftLines  | ForEach-Object { Write-Host $_ -ForegroundColor Magenta }
    $RightLines | ForEach-Object { Write-Host $_ -ForegroundColor DarkMagenta }
  }
} else {
  Write-Host 'FISHTERM' -ForegroundColor DarkMagenta
}

Write-Host ''
