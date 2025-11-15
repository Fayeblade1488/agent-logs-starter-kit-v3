# PowerShell Documentation: `AgentLogs.ps1`

This guide provides comprehensive documentation for the `AgentLogs.ps1` PowerShell script, designed for managing AI agent logs on Windows.

## Prerequisites

-   **Windows:** PowerShell 7+ is required.

## Script Overview

The `AgentLogs.ps1` script is a versatile tool for creating, managing, and automating AI agent logs. It is designed to be run from the command line and supports various targets for different actions.

### Running the Script

To run the script, open a PowerShell 7+ terminal and use the following syntax:

```powershell
pwsh -File .\AgentLogs.ps1 <Target> [-DryRun]
```

-   `<Target>`: The specific action you want to perform (e.g., `New-DailyLog`).
-   `[-DryRun]`: An optional switch for the `Remove-OldLogs` target to see which files would be deleted without actually deleting them.

---

## Function and Target Reference

This section details each of the available functions and targets in the script.

### `New-LogDirs`

-   **Description:** Creates all the necessary log directories (`incidents`, `daily`, `changes`, `notes`, `successful`). This is the first command you should run when setting up the project.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 New-LogDirs
    ```
-   **Output:** `Log directories ready: incidents, daily, changes, notes, successful`

### `New-DailyLog`

-   **Description:** Creates a new log entry in the `daily/` directory with a standard template for daily summaries.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 New-DailyLog
    ```
-   **Output:** `Created daily log: daily/YYYY-MM-DD_daily_TIMESTAMP.md`

### `New-IncidentLog`

-   **Description:** Creates a new incident report in the `incidents/` directory. Use this to document errors, unexpected behavior, or system failures.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 New-IncidentLog
    ```
-   **Output:** `Created incident log: incidents/YYYY-MM-DD_incident_TIMESTAMP.md`

### `New-ChangeLog`

-   **Description:** Creates a new change log in the `changes/` directory. This is ideal for tracking modifications to the system, codebase, or configuration.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 New-ChangeLog
    ```
-   **Output:** `Created change log: changes/YYYY-MM-DD_change_TIMESTAMP.md`

### `New-SuccessLog`

-   **Description:** Creates a new success report in the `successful/` directory. Use this to document positive outcomes or achieved goals.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 New-SuccessLog
    ```
-   **Output:** `Created success log: successful/YYYY-MM-DD_success_TIMESTAMP.md`

### `New-NoteLog`

-   **Description:** Creates a general-purpose note in the `notes/` directory.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 New-NoteLog
    ```
-   **Output:** `Created note log: notes/YYYY-MM-DD_note_TIMESTAMP.md`

### `Get-Logs`

-   **Description:** Lists all existing log files, neatly organized by category.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 Get-Logs
    ```

### `Remove-OldLogs`

-   **Description:** Deletes log files that are older than 30 days. This target supports a `-DryRun` switch to preview the files that will be deleted.
-   **Usage (Dry Run):**
    ```powershell
    pwsh -File .\AgentLogs.ps1 Remove-OldLogs -DryRun
    ```
-   **Usage (Execute):**
    ```powershell
    pwsh -File .\AgentLogs.ps1 Remove-OldLogs
    ```

### `Backup-Logs`

-   **Description:** Creates a compressed `.zip` archive of all the log directories and other project files. The backup is stored in the `.backups/` directory.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 Backup-Logs
    ```
-   **Output:** `Backup created: .\.backups\agent_logs_backup_YYYYMMDD_HHMMSS.zip`

### `Help`

-   **Description:** Displays a help message that lists all available targets. This is the default action if no target is specified.
-   **Usage:**
    ```powershell
    pwsh -File .\AgentLogs.ps1 Help
    # or
    pwsh -File .\AgentLogs.ps1
    ```
