<# AgentLogs.ps1 — Windows PowerShell (Core 7+ recommended) #>
[CmdletBinding()]
param(
  [Parameter(Position=0)]
  [ValidateSet(
    'Help','Show-LoggingPrefs','Update-Readme','New-LogDirs','Get-Logs',
    'Remove-OldLogs',
    'New-IncidentLog','New-ChangeLog','New-SuccessLog','New-NoteLog','New-DailyLog',
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

function Initialize-LogDirs {
  foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

function Help {
@'
Usage: pwsh -File .\AgentLogs.ps1 <Target> [-DryRun]

Targets:
  Help, Show-LoggingPrefs, Update-Readme, New-LogDirs, Get-Logs,
  Remove-OldLogs [-DryRun],
  New-IncidentLog, New-ChangeLog, New-SuccessLog, New-NoteLog, New-DailyLog,
  Backup-Logs
'@ | Write-Output
}

function Show-LoggingPrefs {
@'
Logging Categories: incidents, changes, successful, notes, daily
'@ | Write-Output
}

function Update-Readme { Write-Output "Placeholder for README automation." }

function New-LogDirs { Initialize-LogDirs; Write-Output "Log directories ready: $($Dirs -join ', ')" }

function Get-Logs {
  foreach ($d in $Dirs) {
    Write-Output "=== $($d.Substring(0,1).ToUpper()+$d.Substring(1)) Logs ==="
    if (Test-Path $d) {
      Get-ChildItem -Path $d -File -Force -ErrorAction SilentlyContinue | 
        Select-Object Mode,Length,LastWriteTime,Name |
        Format-Table -AutoSize
    } else {
      Write-Output "No $d logs found"
    }
    Write-Output ""
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

function Remove-OldLogs { param([switch]$DryRun = $true)
  $old = Find-OldLogs -Days 30 | Sort-Object FullName -Unique
  if (-not $old) { Write-Output "No logs older than 30 days."; return }
  if ($DryRun) {
    Write-Output "=== DRY RUN: Would remove the following ==="
    $old | ForEach-Object { Write-Output $_.FullName }
  } else {
    Write-Output "=== EXECUTING: Removing logs older than 30 days ==="
    $old | Remove-Item -Force
    Write-Output "Old log files removed."
  }
}

function Write-LogFile {
  param(
    [Parameter(Mandatory)] [ValidateSet('incident','change','success','note','daily')] [string]$Category,
    [Parameter(Mandatory)] [string]$Title,
    [Parameter(Mandatory)] [string]$Dir
  )
  Initialize-LogDirs
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
  Write-Output "Created $Category log: $filename"
}

function New-IncidentLog { Write-LogFile -Category incident -Title 'Incident Report' -Dir 'incidents' }
function New-ChangeLog   { Write-LogFile -Category change   -Title 'System Change Log' -Dir 'changes' }
function New-SuccessLog  { Write-LogFile -Category success  -Title 'Success Report'    -Dir 'successful' }
function New-NoteLog     { Write-LogFile -Category note     -Title 'Note'              -Dir 'notes' }
function New-DailyLog    { Write-LogFile -Category daily    -Title 'Daily Log'         -Dir 'daily' }

function Backup-Logs {
  Initialize-LogDirs
  $backupDir = '.\.backups'
  New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
  $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
  $zip   = Join-Path $backupDir "agent_logs_backup_$stamp.zip"
  $items = Get-ChildItem -Path . -Force | Where-Object { $_.Name -ne '.backups' }
  if ($items) {
    Compress-Archive -Path $items.FullName -DestinationPath $zip -Force
    Write-Output "Backup created: $zip"
  } else {
    Write-Output "Nothing to back up."
  }
}

switch ($Target) {
  'Help'               { Help }
  'Show-LoggingPrefs'  { Show-LoggingPrefs }
  'Update-Readme'      { Update-Readme }
  'New-LogDirs'        { New-LogDirs }
  'Get-Logs'           { Get-Logs }
  'Remove-OldLogs'     { Remove-OldLogs -DryRun:$DryRun.IsPresent }
  'New-IncidentLog'    { New-IncidentLog }
  'New-ChangeLog'      { New-ChangeLog }
  'New-SuccessLog'     { New-SuccessLog }
  'New-NoteLog'        { New-NoteLog }
  'New-DailyLog'       { New-DailyLog }
  'Backup-Logs'        { Backup-Logs }
  default              { Help }
}
