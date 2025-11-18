<# AgentLogs.ps1 — Windows PowerShell (Core 7+ recommended) #>
[CmdletBinding()]
param(
  [Parameter(Position=0)]
  [ValidateSet(
    'Help','Show-LoggingPrefs','New-LogDirs','Get-Logs',
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

<#
.SYNOPSIS
  Gets the current date and time in various formats.
.DESCRIPTION
  This function retrieves the current date and time and returns it as a custom object with three properties:
  - Date: The current date in 'yyyy-MM-dd' format.
  - Ts: The current Unix timestamp.
  - Iso: The current date and time in UTC ISO 8601 format.
.OUTPUTS
  [pscustomobject] A custom object containing the Date, Ts, and Iso properties.
#>
function Get-DateParts {
  $now = Get-Date
  $date = $now.ToString('yyyy-MM-dd')
  $ts   = [int][double]::Parse((Get-Date -Date $now -UFormat %s))
  $iso  = ($now.ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ssZ")
  [pscustomobject]@{ Date=$date; Ts=$ts; Iso=$iso }
}

<#
.SYNOPSIS
  Creates the log directories.
.DESCRIPTION
  This function creates the necessary directories for storing logs. The directory names are read from the global variable `$Dirs`.
.NOTES
  The function uses `New-Item -ItemType Directory -Force`, so it will not fail if the directories already exist.
#>
function Initialize-LogDirs {
  foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

<#
.SYNOPSIS
  Displays the help message for the script.
.DESCRIPTION
  This function prints a help message to the console, showing the available targets and how to run the script.
#>
function Help {
@'
Usage: pwsh -File .\AgentLogs.ps1 <Target> [-DryRun]

Targets:
  Help, Show-LoggingPrefs, New-LogDirs, Get-Logs,
  Remove-OldLogs [-DryRun],
  New-IncidentLog, New-ChangeLog, New-SuccessLog, New-NoteLog, New-DailyLog,
  Backup-Logs
'@ | Write-Output
}

<#
.SYNOPSIS
  Shows the logging preferences.
.DESCRIPTION
  This function displays the available logging categories.
#>
function Show-LoggingPrefs {
@'
Logging Categories: incidents, changes, successful, notes, daily
'@ | Write-Output
}

<#
.SYNOPSIS
  Creates the log directories.
.DESCRIPTION
  This function initializes the log directories and prints a confirmation message.
#>
function New-LogDirs { Initialize-LogDirs; Write-Output "Log directories ready: $($Dirs -join ', ')" }

<#
.SYNOPSIS
  Lists all logs.
.DESCRIPTION
  This function lists all log files in the log directories, grouped by category.
#>
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

<#
.SYNOPSIS
  Finds old log files.
.DESCRIPTION
  This function finds log files that are older than a specified number of days.
.PARAMETER Days
  The number of days to consider when determining if a log is old. The default is 30.
.OUTPUTS
  [System.IO.FileInfo[]] An array of file info objects for the old log files.
#>
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

<#
.SYNOPSIS
  Removes old log files.
.DESCRIPTION
  This function removes log files that are older than 30 days. It can be run in dry-run mode to see which files would be removed.
.PARAMETER DryRun
  If this switch is present, the function will only list the files that would be removed, without actually deleting them.
#>
function Remove-OldLogs { param([switch]$DryRun = $false)
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

<#
.SYNOPSIS
  Creates a new log file.
.DESCRIPTION
  This function creates a new log file with a standard header and body.
.PARAMETER Category
  The category of the log file. Must be one of 'incident', 'change', 'success', 'note', or 'daily'.
.PARAMETER Title
  The title of the log file.
.PARAMETER Dir
  The directory where the log file will be created.
#>
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

<#
.SYNOPSIS
  Creates a new incident log.
#>
function New-IncidentLog { Write-LogFile -Category incident -Title 'Incident Report' -Dir 'incidents' }
<#
.SYNOPSIS
  Creates a new change log.
#>
function New-ChangeLog   { Write-LogFile -Category change   -Title 'System Change Log' -Dir 'changes' }
<#
.SYNOPSIS
  Creates a new success log.
#>
function New-SuccessLog  { Write-LogFile -Category success  -Title 'Success Report'    -Dir 'successful' }
<#
.SYNOPSIS
  Creates a new note log.
#>
function New-NoteLog     { Write-LogFile -Category note     -Title 'Note'              -Dir 'notes' }
<#
.SYNOPSIS
  Creates a new daily log.
#>
function New-DailyLog    { Write-LogFile -Category daily    -Title 'Daily Log'         -Dir 'daily' }

<#
.SYNOPSIS
  Backs up all logs.
.DESCRIPTION
  This function creates a zip archive of all log files and stores it in the '.backups' directory.
#>
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
