#!/bin/bash

set -e # Exit on error

# Test create_log_dirs
echo "--- Testing create_log_dirs ---"
make -f Makefile.linux create_log_dirs
for d in incidents daily changes notes successful; do
  if [ ! -d "$d" ]; then
    echo "Directory $d was not created."
    exit 1
  fi
done
echo "create_log_dirs test passed."
echo ""

# Test create_daily_log
echo "--- Testing create_daily_log ---"
make -f Makefile.linux create_daily_log
log_file=$(find daily -name "*_daily_*.md" | head -n 1)
if [ -z "$log_file" ]; then
    echo "Daily log file not created."
    exit 1
fi
echo "create_daily_log test passed."
echo ""

# Test create_incident_log
echo "--- Testing create_incident_log ---"
make -f Makefile.linux create_incident_log
log_file=$(find incidents -name "*_incident_*.md" | head -n 1)
if [ -z "$log_file" ]; then
    echo "Incident log file not created."
    exit 1
fi
echo "create_incident_log test passed."
echo ""

# Test create_change_log
echo "--- Testing create_change_log ---"
make -f Makefile.linux create_change_log
log_file=$(find changes -name "*_change_*.md" | head -n 1)
if [ -z "$log_file" ]; then
    echo "Change log file not created."
    exit 1
fi
echo "create_change_log test passed."
echo ""

# Test create_success_log
echo "--- Testing create_success_log ---"
make -f Makefile.linux create_success_log
log_file=$(find successful -name "*_success_*.md" | head -n 1)
if [ -z "$log_file" ]; then
    echo "Success log file not created."
    exit 1
fi
echo "create_success_log test passed."
echo ""

# Test create_note_log
echo "--- Testing create_note_log ---"
make -f Makefile.linux create_note_log
log_file=$(find notes -name "*_note_*.md" | head -n 1)
if [ -z "$log_file" ]; then
    echo "Note log file not created."
    exit 1
fi
echo "create_note_log test passed."
echo ""

# Test list_logs
echo "--- Testing list_logs ---"
output=$(make -f Makefile.linux list_logs)
if ! echo "$output" | grep -q "=== Daily Logs ==="; then
    echo "list_logs output is incorrect."
    exit 1
fi
echo "list_logs test passed."
echo ""

# Test clean_old_logs with a missing directory
echo "--- Testing clean_old_logs with a missing directory ---"
make -f Makefile.linux create_log_dirs
touch -d "31 days ago" daily/old_log.md
rm -rf incidents
output=$(make -f Makefile.linux clean_old_logs)
if ! echo "$output" | grep -q "daily/old_log.md"; then
    echo "clean_old_logs did not find the old file."
    exit 1
fi
echo "clean_old_logs with a missing directory test passed."
echo ""

# Test clean_old_logs_execute with a missing directory
echo "--- Testing clean_old_logs_execute with a missing directory ---"
make -f Makefile.linux create_log_dirs
touch -d "31 days ago" daily/old_log.md
rm -rf incidents
make -f Makefile.linux clean_old_logs_execute
if [ -f "daily/old_log.md" ]; then
    echo "clean_old_logs_execute did not remove the old file."
    exit 1
fi
echo "clean_old_logs_execute with a missing directory test passed."
echo ""

# Test backup_logs
echo "--- Testing backup_logs ---"
make -f Makefile.linux create_note_log # Create a file to backup
make -f Makefile.linux backup_logs
backup_file=$(find .backups -name "agent_logs_backup_*.tar.gz" | head -n 1)
if [ -z "$backup_file" ]; then
    echo "Backup file not created."
    exit 1
fi
echo "backup_logs test passed."
echo ""


# Cleanup
rm -rf incidents daily changes notes successful .backups

echo "All Makefile tests passed!"
