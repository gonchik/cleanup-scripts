#!/usr/bin/env bash
#
# cleanup_logs.sh - quick system log cleanup.
# Kept for backwards compatibility: it's a shortcut for `logs_reviewer.sh --system-only`
# (~/Library/Logs, /Library/Logs, /var/log).
#
# Usage: ./cleanup_logs.sh [-n|--dry-run] [DAYS]   e.g. `./cleanup_logs.sh 7` = only logs older than 7 days
#        Any other logs_reviewer.sh option is passed through.

set -euo pipefail

ARGS=(--system-only)
for a in "$@"; do
    if [[ "$a" =~ ^[0-9]+$ ]]; then ARGS+=(--older-than "$a"); else ARGS+=("$a"); fi
done

exec "$(cd "$(dirname "$0")" && pwd)/logs_reviewer.sh" "${ARGS[@]}"
