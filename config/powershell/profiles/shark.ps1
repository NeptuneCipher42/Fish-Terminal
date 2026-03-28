#################################################################################################
# Author: Nicholas Fisher
# Date: March 25th 2026
# Description of Script
# SharkTerminal PowerShell shark profile — Oh My Posh shark theme, modern CLI aliases,
# zoxide, PSFzf, PSReadLine enhancements, and ASCII art greeting.
#################################################################################################
$STRoot = if ($global:SHARKTERMINAL_ROOT) { $global:SHARKTERMINAL_ROOT } else { Join-Path $HOME '.config/sharkterminal' }

# ---------------------------------------------------------------------------
# UTF-8 everywhere — required for emoji and Nerd Font glyphs to render
# ---------------------------------------------------------------------------
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

# VS Code shell integration (enables terminal links, run-in-terminal, etc.)
if ($env:TERM_PROGRAM -eq 'vscode') {
  $vscodeIntegration = code --locate-shell-integration-path pwsh 2>$null
  if ($vscodeIntegration) { . $vscodeIntegration }
}

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
# PSReadLine — optimized: deduplication, capped history, no ding, HistoryAndPlugin
# ---------------------------------------------------------------------------
if (Get-Module -ListAvailable -Name PSReadLine -ErrorAction SilentlyContinue) {
  Import-Module PSReadLine
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -MaximumHistoryCount 5000
  Set-PSReadLineOption -HistoryNoDuplicates
  Set-PSReadLineOption -DingTone 0
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
}

# ---------------------------------------------------------------------------
# PSFzf — lazy-loaded on first Ctrl+F / Ctrl+R (saves ~400ms startup)
# ---------------------------------------------------------------------------
function global:_LoadPSFzf {
  if (-not (Get-Module PSFzf -ErrorAction SilentlyContinue)) {
    if (Get-Module -ListAvailable -Name PSFzf -ErrorAction SilentlyContinue) {
      Import-Module PSFzf
      Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
  }
}
Set-PSReadLineKeyHandler -Key Ctrl+f -ScriptBlock { _LoadPSFzf; Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { _LoadPSFzf; Invoke-FuzzyHistory }

# ---------------------------------------------------------------------------
# zoxide — smarter cd
# ---------------------------------------------------------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# posh-git removed — Oh My Posh handles all git display natively

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
# Greeting — mirrors fish_greeting.fish with exact #FF79C6 / #BD93F9 colors
# ---------------------------------------------------------------------------
$KrakenBanner   = Join-Path $STRoot 'banner/kraken.txt'
$FishtermBanner = Join-Path $STRoot 'banner/fishterm.txt'

$Pink   = "`e[38;2;255;121;198m"   # #FF79C6
$Purple = "`e[38;2;189;147;249m"   # #BD93F9
$Reset  = "`e[0m"

Write-Host ''
Write-Host "${Pink}🐙  Cracken's Cavern  🐙${Reset}"
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
      $RightColor = if ($i % 2 -eq 0) { $Pink } else { $Purple }
      if ($Right) {
        $Padded = $Left.PadRight(30)
        Write-Host "${Purple}${Padded}${Reset}  ${RightColor}${Right}${Reset}"
      } else {
        Write-Host "${Purple}${Left}${Reset}"
      }
    }
  } else {
    $LeftLines  | ForEach-Object { Write-Host "${Purple}${_}${Reset}" }
    $i = 0
    $RightLines | ForEach-Object {
      $c = if ($i % 2 -eq 0) { $Pink } else { $Purple }
      Write-Host "${c}${_}${Reset}"
      $i++
    }
  }
} else {
  Write-Host "${Pink}FISHTERM${Reset}"
}

Write-Host ''
