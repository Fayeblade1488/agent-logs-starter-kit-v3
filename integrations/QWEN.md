# QWEN Integration Guide

This file shows a simple, **actionable policy** for Qwen-based agents to use the logs in this folder.

## TL;DR
- On `/init`, ensure directories exist and create a **Daily** log.
- After errors or unexpected behavior → create an **Incident** log.
- After config/env edits (packages, tokens, model switches) → create a **Change** log.
- After a successful task worth remembering → create a **Success** log.
- For scratch or operator context → create a **Note** log.

## Commands (run from `.agent-logs/`)
**macOS**
```bash
make -f Makefile.macos create_log_dirs
make -f Makefile.macos create_daily_log
```
**Linux**
```bash
make -f Makefile.linux create_log_dirs
make -f Makefile.linux create_daily_log
```
**Windows**
```pwsh
.\AgentLogs.ps1 Create-LogDirs
.\AgentLogs.ps1 Create-DailyLog
```

## Minimal Agent Policy (Qwen)
1) Always respect the YAML front matter in created files: `title`, `date` (ISO), `category`.

2) Never store secrets, access tokens, or personal identifiers in logs. Redact if needed.

3) Prefer **many small logs** over one giant note.

4) If a command fails or tool call returns an error, immediately create an **Incident** log with:

   - Summary of what failed

   - Inputs/assumptions (non-sensitive)

   - Remediation steps attempted

   - Result and next actions

5) If the user says “note: …” → create a **Note** log with that text.

6) After visible state changes (package install, config edit) → **Change** log.

7) At the end of a session → **Daily** log summarizing highlights, tasks, blockers, decisions.


## Example: `/init` flow
```
/init
- ensure dirs → create daily log → confirm location of new file
- ask if the user wants automatic incident/change logging enabled this session
```

## Example: create a Success log after a pass
```
make -f Makefile.linux create_success_log
# or
pwsh -File .\AgentLogs.ps1 Create-SuccessLog
```

Qwen agents can safely rely on these commands without additional dependencies.
