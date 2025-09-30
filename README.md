# Agent Logs Starter Kit

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A universal, cross-platform logging system for AI agents.

## Overview

This starter kit provides a robust and universal logging scaffold for AI agents. Capturing AI interactions is crucial for traceability, auditability, and continuity. This system is designed to be simple, machine-readable, and extensible.

Logs are stored as Markdown files with YAML front matter, making them easy to parse for both humans and AIs.

## Features

-   **Cross-Platform:** Supports macOS, Linux, and Windows (with PowerShell 7+).
-   **Structured Logging:** Uses Markdown with YAML front matter for easy parsing.
-   **Log Categories:** Organizes logs into incidents, changes, successes, notes, and daily summaries.
-   **Automation:** Includes Makefiles and a PowerShell script for common tasks.
-   **Backup and Restore:** Built-in commands for backing up and restoring logs.

## Prerequisites

-   **macOS/Linux:** `make`
-   **Windows:** PowerShell 7+

## Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/your-username/agent-logs-starter-kit-v3.git
    cd agent-logs-starter-kit-v3
    ```
2.  Initialize the log directories:
    -   **macOS:** `make -f Makefile.macos create_log_dirs`
    -   **Linux:** `make -f Makefile.linux create_log_dirs`
    -   **Windows:** `.\AgentLogs.ps1 Create-LogDirs`

## Usage

### Creating Logs

-   **Daily Log:**
    -   macOS: `make -f Makefile.macos create_daily_log`
    -   Linux: `make -f Makefile.linux create_daily_log`
    -   Windows: `.\AgentLogs.ps1 Create-DailyLog`
-   **Incident Log:**
    -   macOS: `make -f Makefile.macos create_incident_log`
    -   Linux: `make -f Makefile.linux create_incident_log`
    -   Windows: `.\AgentLogs.ps1 Create-IncidentLog`
-   **Change Log:**
    -   macOS: `make -f Makefile.macos create_change_log`
    -   Linux: `make -f Makefile.linux create_change_log`
    -   Windows: `.\AgentLogs.ps1 Create-ChangeLog`
-   **Success Log:**
    -   macOS: `make -f Makefile.macos create_success_log`
    -   Linux: `make -f Makefile.linux create_success_log`
    -   Windows: `.\AgentLogs.ps1 Create-SuccessLog`
-   **Note Log:**
    -   macOS: `make -f Makefile.macos create_note_log`
    -   Linux: `make -f Makefile.linux create_note_log`
    -   Windows: `.\AgentLogs.ps1 Create-NoteLog`

### Other Commands

-   **List Logs:**
    -   macOS: `make -f Makefile.macos list_logs`
    -   Linux: `make -f Makefile.linux list_logs`
    -   Windows: `.\AgentLogs.ps1 List-Logs`
-   **Backup Logs:**
    -   macOS: `make -f Makefile.macos backup_logs`
    -   Linux: `make -f Makefile.linux backup_logs`
    -   Windows: `.\AgentLogs.ps1 Backup-Logs`
-   **Clean Old Logs (Dry Run):**
    -   macOS: `make -f Makefile.macos clean_old_logs`
    -   Linux: `make -f Makefile.linux clean_old_logs`
    -   Windows: `.\AgentLogs.ps1 Clean-OldLogs -DryRun`
-   **Clean Old Logs (Execute):**
    -   macOS: `make -f Makefile.macos clean_old_logs_execute`
    -   Linux: `make -f Makefile.linux clean_old_logs_execute`
    -   Windows: `.\AgentLogs.ps1 Clean-OldLogs`

## Integrations

See the `integrations` directory for agent-specific guidance.

## Contributing

Contributions are welcome! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.