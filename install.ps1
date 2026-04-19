# Install Viral's custom Claude Code agents (PowerShell).
#
# Usage (run from the cloned repo root):
#   .\install.ps1                               # global install to ~/.claude/  (recommended)
#   .\install.ps1 -Project C:\code\my-app       # install into a specific project
#   .\install.ps1 -Project . -NoClaudeMd        # don't copy CLAUDE.md
#   .\install.ps1 -Help

param(
    [string]$Project = "",
    [switch]$NoClaudeMd,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
Usage: .\install.ps1 [options]

Install Viral's custom Claude Code agents.

Options:
  (no args)               Install globally to ~/.claude/  (recommended)
  -Project <path>         Install into a specific project's .claude/ folder
  -NoClaudeMd             Skip copying CLAUDE.md
  -Help                   Show this help

Examples:
  .\install.ps1
  .\install.ps1 -Project C:\code\my-app
  .\install.ps1 -Project . -NoClaudeMd
"@
    exit 0
}

$ErrorActionPreference = "Stop"

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$AgentsSrc   = Join-Path $ScriptDir ".claude\agents"
$ClaudeMdSrc = Join-Path $ScriptDir "CLAUDE.md"

if (-not (Test-Path $AgentsSrc)) {
    Write-Host "Could not find $AgentsSrc" -ForegroundColor Red
    Write-Host "Run this script from the cloned repo root." -ForegroundColor Red
    exit 1
}

if ($Project) {
    if (-not (Test-Path $Project -PathType Container)) {
        Write-Host "Target is not a directory: $Project" -ForegroundColor Red
        exit 1
    }
    $Target       = (Resolve-Path $Project).Path
    $DestAgents   = Join-Path $Target ".claude\agents"
    $DestClaudeMd = Join-Path $Target "CLAUDE.md"
    $Mode         = "project"
    Write-Host "Project install -> $Target"
}
else {
    $DestRoot     = Join-Path $HOME ".claude"
    $DestAgents   = Join-Path $DestRoot "agents"
    $DestClaudeMd = Join-Path $DestRoot "CLAUDE.md"
    $Mode         = "global"
    Write-Host "Global install -> $DestRoot"
}

New-Item -ItemType Directory -Force -Path $DestAgents | Out-Null
$Agents = Get-ChildItem -Path $AgentsSrc -Filter "*.md" -File
foreach ($agent in $Agents) {
    Copy-Item -Path $agent.FullName -Destination $DestAgents -Force
}
Write-Host "Copied $($Agents.Count) agent(s) to $DestAgents" -ForegroundColor Green

if (-not $NoClaudeMd -and (Test-Path $ClaudeMdSrc)) {
    $ClaudeMdDir = Split-Path -Parent $DestClaudeMd
    New-Item -ItemType Directory -Force -Path $ClaudeMdDir | Out-Null
    Copy-Item -Path $ClaudeMdSrc -Destination $DestClaudeMd -Force
    Write-Host "Copied CLAUDE.md -> $DestClaudeMd" -ForegroundColor Green
}

if ($Mode -eq "project") {
    $Gitignore = Join-Path $Target ".gitignore"
    if (-not (Test-Path $Gitignore)) {
        New-Item -ItemType File -Path $Gitignore -Force | Out-Null
    }
    $Existing = @(Get-Content $Gitignore -ErrorAction SilentlyContinue)
    $Entries  = @(".claude/agents/", "CLAUDE.md", "viral-agents.md")
    $Added    = 0
    foreach ($entry in $Entries) {
        if ($Existing -notcontains $entry) {
            Add-Content -Path $Gitignore -Value $entry
            $Added++
        }
    }
    if ($Added -gt 0) {
        Write-Host "Added $Added entry(s) to $Gitignore" -ForegroundColor Green
    }
    else {
        Write-Host ".gitignore already has the needed entries"
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Cyan
Write-Host "Next: open Claude Code in your project and run the 'project-scout' agent"
Write-Host "      to generate viral-agents.md."
