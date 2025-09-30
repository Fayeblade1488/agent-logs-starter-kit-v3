# WARP Integration Guide (macOS terminal)

Warp users can add a simple **Global Rule** so every session has consistent logs.

## TL;DR
- First run: create folders and a daily log.

- During work: incident on errors; change on config edits; success on confirmed outcomes; notes as needed.


## One-time init (macOS)
```bash
cd ~/.agent-logs   # or your chosen path
make -f Makefile.macos create_log_dirs
make -f Makefile.macos create_daily_log
```

## Suggested Global Rule (pseudo-YAML)
This is a conceptual example; adapt to Warp’s rule format.
```yaml
name: agent-logs-defaults
triggers:
  - on_session_start: true
  - on_command_error: true
  - on_keyword: ["note:", "/incident", "/change", "/success", "/daily"]
actions:
  on_session_start:
    - run: "cd ~/.agent-logs && make -f Makefile.macos create_log_dirs && make -f Makefile.macos create_daily_log"
  on_command_error:
    - run: "cd ~/.agent-logs && make -f Makefile.macos create_incident_log"
  on_keyword:
    - match: "note:"
      run: "cd ~/.agent-logs && make -f Makefile.macos create_note_log"
    - match: "/incident"
      run: "cd ~/.agent-logs && make -f Makefile.macos create_incident_log"
    - match: "/change"
      run: "cd ~/.agent-logs && make -f Makefile.macos create_change_log"
    - match: "/success"
      run: "cd ~/.agent-logs && make -f Makefile.macos create_success_log"
    - match: "/daily"
      run: "cd ~/.agent-logs && make -f Makefile.macos create_daily_log"
notes:
  - Never log secrets/tokens; redact as needed.
  - Keep entries small and frequent.
```

## Manual commands you can paste into Warp
```bash
make -f Makefile.macos create_incident_log
make -f Makefile.macos create_change_log
make -f Makefile.macos create_success_log
make -f Makefile.macos create_note_log
make -f Makefile.macos create_daily_log
```
