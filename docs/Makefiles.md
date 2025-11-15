# Makefile Documentation

This guide provides comprehensive documentation for the `Makefile.linux` and `Makefile.macos` files, which are used to manage AI agent logs on Linux and macOS systems.

## Prerequisites

-   **Linux or macOS:** A terminal with `make` and standard Unix commands is required.

## Makefile Overview

The Makefiles provide a set of convenient targets for creating, managing, and automating AI agent logs. They are designed to be run from the command line.

### Running the Makefiles

To run a command, open a terminal and use the following syntax, specifying the appropriate Makefile for your operating system:

**For Linux:**

```bash
make -f Makefile.linux <target>
```

**For macOS:**

```bash
make -f Makefile.macos <target>
```

-   `<target>`: The specific action you want to perform (e.g., `create_daily_log`).

---

## Target Reference

This section details each of the available targets. The commands are the same for both `Makefile.linux` and `Makefile.macos`.

### `create_log_dirs`

-   **Description:** Creates all the necessary log directories (`incidents`, `daily`, `changes`, `notes`, `successful`). This is the first command you should run when setting up the project.
-   **Usage:**
    ```bash
    make -f Makefile.linux create_log_dirs
    ```
-   **Output:** `Ready: incidents daily changes notes successful`

### `create_daily_log`

-   **Description:** Creates a new log entry in the `daily/` directory with a standard template for daily summaries.
-   **Usage:**
    ```bash
    make -f Makefile.linux create_daily_log
    ```
-   **Output:** `Created daily log: daily/YYYY-MM-DD_daily_TIMESTAMP.md`

### `create_incident_log`

-   **Description:** Creates a new incident report in the `incidents/` directory. Use this to document errors, unexpected behavior, or system failures.
-   **Usage:**
    ```bash
    make -f Makefile.linux create_incident_log
    ```
-   **Output:** `Created incident log: incidents/YYYY-MM-DD_incident_TIMESTAMP.md`

### `create_change_log`

-   **Description:** Creates a new change log in the `changes/` directory. This is ideal for tracking modifications to the system, codebase, or configuration.
-   **Usage:**
    ```bash
    make -f Makefile.linux create_change_log
    ```
-   **Output:** `Created change log: changes/YYYY-MM-DD_change_TIMESTAMP.md`

### `create_success_log`

-   **Description:** Creates a new success report in the `successful/` directory. Use this to document positive outcomes or achieved goals.
-   **Usage:**
    ```bash
    make -f Makefile.linux create_success_log
    ```
-   **Output:** `Created success log: successful/YYYY-MM-DD_success_TIMESTAMP.md`

### `create_note_log`

-   **Description:** Creates a general-purpose note in the `notes/` directory.
-   **Usage:**
    ```bash
    make -f Makefile.linux create_note_log
    ```
-   **Output:** `Created note log: notes/YYYY-MM-DD_note_TIMESTAMP.md`

### `list_logs`

-   **Description:** Lists all existing log files, neatly organized by category.
-   **Usage:**
    ```bash
    make -f Makefile.linux list_logs
    ```

### `clean_old_logs`

-   **Description:** Performs a dry run of the cleaning process, showing which log files older than 30 days would be deleted without actually deleting them.
-   **Usage:**
    ```bash
    make -f Makefile.linux clean_old_logs
    ```

### `clean_old_logs_execute`

-   **Description:** Deletes all log files that are older than 30 days.
-   **Usage:**
    ```bash
    make -f Makefile.linux clean_old_logs_execute
    ```

### `backup_logs`

-   **Description:** Creates a compressed `.tar.gz` archive of all the log directories and other project files. The backup is stored in the `.backups/` directory.
-   **Usage:**
    ```bash
    make -f Makefile.linux backup_logs
    ```
-   **Output:** `Backup created: .backups/agent_logs_backup_YYYYMMDD_HHMMSS.tar.gz`

### `help`

-   **Description:** Displays a help message that lists all available targets. This is the default action if no target is specified.
-   **Usage:**
    ```bash
    make -f Makefile.linux help
    # or
    make -f Makefile.linux
    ```
