<# AgentLogs.ps1 — Windows PowerShell (Core 7+ recommended) #>
[CmdletBinding()]
param(
  [Parameter(Position=0)]
  [ValidateSet(
    'Help','Show-LoggingPrefs','Update-Readme','Create-LogDirs','List-Logs',
    'Clean-OldLogs','Remove-OldLogs',
    'Create-IncidentLog','Create-ChangeLog','Create-SuccessLog','Create-NoteLog','Create-DailyLog',
    'Backup-Logs'
  )]
  [string]$Target = 'Help',
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Dirs = @('incidents','daily','changes','notes','successful')
$Ext  = 'md'

function Get-DateParts {
  $now = Get-Date
  $date = $now.ToString('yyyy-MM-dd')
  $ts   = [int][double]::Parse((Get-Date -Date $now -UFormat %s))
  $iso  = ($now.ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ssZ")
  [pscustomobject]@{ Date=$date; Ts=$ts; Iso=$iso }
}

function Ensure-LogDirs {
  foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

function Help {
@'
Usage: pwsh -File .\AgentLogs.ps1 <Target> [-DryRun]

Targets:
  Help, Show-LoggingPrefs, Update-Readme, Create-LogDirs, List-Logs,
  Clean-OldLogs [-DryRun], Remove-OldLogs,
  Create-IncidentLog, Create-ChangeLog, Create-SuccessLog, Create-NoteLog, Create-DailyLog,
  Backup-Logs
'@ | Write-Host
}

function Show-LoggingPrefs {
@'
Logging Categories: incidents, changes, successful, notes, daily
'@ | Write-Host
}

function Update-Readme { Write-Host "Placeholder for README automation." }

function Create-LogDirs { Ensure-LogDirs; Write-Host "Log directories ready: $($Dirs -join ', ')" }

function List-Logs {
  foreach ($d in $Dirs) {
    Write-Host "=== $($d.Substring(0,1).ToUpper()+$d.Substring(1)) Logs ==="
    if (Test-Path $d) {
      Get-ChildItem -Path $d -File -Force -ErrorAction SilentlyContinue | 
        Select-Object Mode,Length,LastWriteTime,Name |
        Format-Table -AutoSize
    } else {
      Write-Host "No $d logs found"
    }
    Write-Host ""
  }
}

function Find-OldLogs {
  param([int]$Days = 30)
  $cutoff = (Get-Date).AddDays(-$Days)
  foreach ($d in $Dirs) {
    if (Test-Path $d) {
      Get-ChildItem -Path $d -Filter "*.$Ext" -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt $cutoff }
    }
  }
}

function Clean-OldLogs { param([switch]$DryRun = $true)
  $old = Find-OldLogs -Days 30 | Sort-Object FullName -Unique
  if (-not $old) { Write-Host "No logs older than 30 days."; return }
  if ($DryRun) {
    Write-Host "=== DRY RUN: Would remove the following ==="
    $old | ForEach-Object { Write-Host $_.FullName }
  } else {
    Write-Host "=== EXECUTING: Removing logs older than 30 days ==="
    $old | Remove-Item -Force
    Write-Host "Old log files removed."
  }
}

function Remove-OldLogs { Clean-OldLogs -DryRun:$false }

function Write-LogFile {
  param(
    [Parameter(Mandatory)] [ValidateSet('incident','change','success','note','daily')] [string]$Category,
    [Parameter(Mandatory)] [string]$Title,
    [Parameter(Mandatory)] [string]$Dir
  )
  Ensure-LogDirs
  $p = Get-DateParts
  $filename = Join-Path $Dir ("{0}_{1}_{2}.{3}" -f $p.Date,$Category,$p.Ts,$Ext)
  $header = @('---',"title: $Title","date: $($p.Iso)","category: $Category",'---','')
  $body = switch ($Category) {
    'incident' { @("# Incident Report - $($p.Date)",'','## Summary','','## Context','','## Actions Taken','','## Outcome','','## Follow-up Required','','## Resolution') }
    'change'   { @("# Change Log - $($p.Date)",'','## Summary','','## Context','','## Changes Made','','## Outcome','','## Follow-up Required') }
    'success'  { @("# Success Report - $($p.Date)",'','## Summary','','## Context','','## Actions Taken','','## Outcome','','## Follow-up Required') }
    'note'     { @("# Note - $($p.Date)",'','## Summary','','## Content','','## Follow-up Required') }
    'daily'    { @("# Daily Log - $($p.Date)",'','## Highlights','','## Tasks','','## Blockers','','## Notes') }
  }
  ($header + $body + @('','')) | Set-Content -Encoding UTF8 -Path $filename
  Write-Host "Created $Category log: $filename"
}

function Create-IncidentLog { Write-LogFile -Category incident -Title 'Incident Report' -Dir 'incidents' }
function Create-ChangeLog   { Write-LogFile -Category change   -Title 'System Change Log' -Dir 'changes' }
function Create-SuccessLog  { Write-LogFile -Category success  -Title 'Success Report'    -Dir 'successful' }
function Create-NoteLog     { Write-LogFile -Category note     -Title 'Note'              -Dir 'notes' }
function Create-DailyLog    { Write-LogFile -Category daily    -Title 'Daily Log'         -Dir 'daily' }

function Backup-Logs {
  Ensure-LogDirs
  $backupDir = '.\.backups'
  New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
  $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
  $zip   = Join-Path $backupDir "agent_logs_backup_$stamp.zip"
  $items = Get-ChildItem -Path . -Force | Where-Object { $_.Name -ne '.backups' }
  if ($items) {
    Compress-Archive -Path $items.FullName -DestinationPath $zip -Force
    Write-Host "Backup created: $zip"
  } else {
    Write-Host "Nothing to back up."
  }
}

switch ($Target) {
  'Help'               { Help }
  'Show-LoggingPrefs'  { Show-LoggingPrefs }
  'Update-Readme'      { Update-Readme }
  'Create-LogDirs'     { Create-LogDirs }
  'List-Logs'          { List-Logs }
  'Clean-OldLogs'      { Clean-OldLogs -DryRun:$DryRun.IsPresent }
  'Remove-OldLogs'     { Remove-OldLogs }
  'Create-IncidentLog' { Create-IncidentLog }
  'Create-ChangeLog'   { Create-ChangeLog }
  'Create-SuccessLog'  { Create-SuccessLog }
  'Create-NoteLog'     { Create-NoteLog }
  'Create-DailyLog'    { Create-DailyLog }
  'Backup-Logs'        { Backup-Logs }
  default              { Help }
}
