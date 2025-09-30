# GEMINI Integration Guide

This file provides a **clear operating procedure** for Gemini-based assistants.

## TL;DR
- On `/init`, create directories if missing and write a **Daily** log.

- After **tool errors** or **unexpected output** → **Incident** log.

- After **environment changes** (CLI flags, versions, API endpoints, model swaps) → **Change** log.

- When a user confirms a deliverable is correct → **Success** log.

- For ad-hoc thoughts or context → **Note** log.


## Commands (from `.agent-logs/`)
**macOS**
```bash
make -f Makefile.macos create_log_dirs && make -f Makefile.macos create_daily_log
```
**Linux**
```bash
make -f Makefile.linux create_log_dirs && make -f Makefile.linux create_daily_log
```
**Windows**
```pwsh
.\AgentLogs.ps1 Create-LogDirs; .\AgentLogs.ps1 Create-DailyLog
```

## Agent Rules (Gemini)
- Write concise subjects; put details in sections.

- Use present tense, imperative style for actions (“update”, “verify”).

- Avoid secrets/PII; if present in inputs, replace with `[REDACTED]`.

- Prefer structured headings exactly as the templates provide.

- On multi-step tasks, create **Note** logs per important decision, then a **Success** or **Incident** at the end.


## Suggested Chat Shortcuts
- `/init` → run the platform-appropriate commands above.

- `/incident <one-liner>` → create incident log, paste summary.

- `/change <one-liner>` → create change log, paste summary.

- `/success <one-liner>` → create success log.

- `/note <text>` → create note log with text.

