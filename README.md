# Agent Logs Starter Kit

<img width="1024" height="1024" alt="ashley" src="https://github.com/user-attachments/assets/5a2eb7ae-054d-442f-bdac-6934fb5b40dc" />

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

## Getting Started

### Prerequisites

-   **macOS/Linux:** `make`
-   **Windows:** PowerShell 7+

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/your-username/agent-logs-starter-kit-v3.git
    cd agent-logs-starter-kit-v3
    ```
2.  Initialize the log directories for your platform:
    -   **macOS:** `make -f Makefile.macos create_log_dirs`
    -   **Linux:** `make -f Makefile.linux create_log_dirs`
    -   **Windows:** `pwsh -File .\AgentLogs.ps1 New-LogDirs`

## Usage

Commands are run using `make` on macOS/Linux and `pwsh` on Windows.

### Creating Logs

-   **Daily Log:**
    -   macOS: `make -f Makefile.macos create_daily_log`
    -   Linux: `make -f Makefile.linux create_daily_log`
    -   Windows: `pwsh -File .\AgentLogs.ps1 New-DailyLog`
-   **Incident Log:**
    -   macOS: `make -f Makefile.macos create_incident_log`
    -   Linux: `make -f Makefile.linux create_incident_log`
    -   Windows: `pwsh -File .\AgentLogs.ps1 New-IncidentLog`
-   **Change Log:**
    -   macOS: `make -f Makefile.macos create_change_log`
    -   Linux: `make -f Makefile.linux create_change_log`
    -   Windows: `pwsh -File .\AgentLogs.ps1 New-ChangeLog`
-   **Success Log:**
    -   macOS: `make -f Makefile.macos create_success_log`
    -   Linux: `make -f Makefile.linux create_success_log`
    -   Windows: `pwsh -File .\AgentLogs.ps1 New-SuccessLog`
-   **Note Log:**
    -   macOS: `make -f Makefile.macos create_note_log`
    -   Linux: `make -f Makefile.linux create_note_log`
    -   Windows: `pwsh -File .\AgentLogs.ps1 New-NoteLog`

### Managing Logs

-   **List Logs:**
    -   macOS: `make -f Makefile.macos list_logs`
    -   Linux: `make -f Makefile.linux list_logs`
    -   Windows: `pwsh -File .\AgentLogs.ps1 Get-Logs`
-   **Backup Logs:**
    -   macOS: `make -f Makefile.macos backup_logs`
    -   Linux: `make -f Makefile.linux backup_logs`
    -   Windows: `pwsh -File .\AgentLogs.ps1 Backup-Logs`
-   **Clean Old Logs (Dry Run):**
    -   macOS: `make -f Makefile.macos clean_old_logs`
    -   Linux: `make -f Makefile.linux clean_old_logs`
    -   Windows: `pwsh -File .\AgentLogs.ps1 Remove-OldLogs -DryRun`
-   **Clean Old Logs (Execute):**
    -   macOS: `make -f Makefile.macos clean_old_logs_execute`
    -   Linux: `make -f Makefile.linux clean_old_logs_execute`
    -   Windows: `pwsh -File .\AgentLogs.ps1 Remove-OldLogs`

## For AI Agents

This repository includes a machine-readable instruction file, `ai_instructions.yml`, designed for AI agents. This file provides structured details on the repository's purpose, setup, and available commands.

To get started, parse and use `ai_instructions.yml` for automated setup and operation.

## Integrations

See the `integrations` directory for agent-specific guidance.

## Contributing

Contributions are welcome! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.