#!/usr/bin/env bash
#
# logs_reviewer.sh - fast deep-search and smart cleaner for macOS logs & crash reports.
#
# Usage: ./logs_reviewer.sh [options]
#   -n, --dry-run          list what would be cleaned, change nothing
#   -a, --all              list every file instead of the top 25
#   -d, --older-than DAYS  only files not modified for more than DAYS days
#   -s, --system-only      only ~/Library/Logs, /Library/Logs and /var/log
#   -y, --yes              don't ask for confirmation
#   -h, --help
#
# Logs of running processes are truncated (keeps open file descriptors valid),
# everything else (rotated archives, crash reports) is deleted.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() { sed -n '3,14p' "$0" | sed 's/^# \{0,1\}//'; }

DRY_RUN=0
ASSUME_YES=0
SYSTEM_ONLY=0
TOP_N=25
MIN_AGE_DAYS=0
while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run) DRY_RUN=1 ;;
        -a|--all) TOP_N=1000000 ;;
        -s|--system-only) SYSTEM_ONLY=1 ;;
        -y|--yes) ASSUME_YES=1 ;;
        -d|--older-than)
            [[ "${2:-}" =~ ^[0-9]+$ ]] || { echo "--older-than needs a number of days" >&2; exit 1; }
            MIN_AGE_DAYS=$2; shift ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 1 ;;
    esac
    shift
done

[ "$(uname)" = "Darwin" ] || { echo "This script is for macOS only." >&2; exit 1; }

echo -e "${BLUE}=== macOS log analysis ===${NC}\n"

TMP_DIRS=$(mktemp)
TMP_RAW_LOGS=$(mktemp)
TMP_DEDUP=$(mktemp)
TMP_PS=$(mktemp)
trap 'rm -f "$TMP_DIRS" "$TMP_RAW_LOGS" "$TMP_DEDUP" "$TMP_PS"' EXIT

format_bytes() {
    awk -v b="$1" 'BEGIN {
        if (b >= 1073741824) printf "%.2f GB", b/1073741824;
        else if (b >= 1048576) printf "%.2f MB", b/1048576;
        else if (b >= 1024) printf "%.2f KB", b/1024;
        else printf "%d B", b;
    }'
}

# Guess which process owns a log file (from its folder or file name)
get_process_name() {
    local file_path="$1"
    local base_name parent_dir clean_name
    base_name=$(basename "$file_path")
    parent_dir=$(basename "$(dirname "$file_path")")

    case "$parent_dir" in
        Logs|log|logs|_logs|DiagnosticReports|Retired|var) ;;
        *) echo "$parent_dir"; return ;;
    esac

    clean_name="${base_name%.*}"
    clean_name=$(echo "$clean_name" | sed -E 's/[-_][0-9]{4}-[0-9]{2}-[0-9]{2}.*//')

    if [[ "$clean_name" == *.* ]]; then
        echo "${clean_name##*.}"
    else
        echo "$clean_name"
    fi
}

# Take one process snapshot up front (calling pgrep per file is very slow)
ps -axo command= 2>/dev/null | tr '[:upper:]' '[:lower:]' > "$TMP_PS"

is_process_running() {
    local proc
    proc=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    [ "${#proc}" -lt 3 ] && return 1

    # Generic names would match almost any command line
    case "$proc" in
        log|logs|main|app|server|output|error|debug|system|install|daemon|shutdown*)
            return 1
            ;;
    esac

    grep -qF -- "$proc" "$TMP_PS"
}

# Empty a file in place; use sudo for root-owned files. macOS has no `truncate` utility.
zero_file() {
    { : > "$1"; } 2>/dev/null || sudo sh -c ': > "$1"' _ "$1" 2>/dev/null
}

# 1. Collect log directories
# IMPORTANT: never add ~/.cargo, DerivedData or other source/package folders here:
# the *.txt / *.gz patterns would delete LICENSE.txt, CMakeLists.txt etc. and break builds.
echo -e "${YELLOW}[1/3] Indexing log directories...${NC}"

{
    echo "$HOME/Library/Logs"
    echo "/Library/Logs"
    echo "/private/var/log"   # /var/log is a symlink to this
} >> "$TMP_DIRS"

if [ "$SYSTEM_ONLY" -eq 0 ]; then
    {
        echo "$HOME/.npm/_logs"
        echo "$HOME/.pm2/logs"
        echo "$HOME/.gradle/daemon"
        echo "$HOME/Library/Developer/Xcode/iOS Device Logs"
    } >> "$TMP_DIRS"

    # Only folders named Logs / DiagnosticReports inside app containers
    find "$HOME/Library/Containers" "$HOME/Library/Group Containers" "$HOME/Library/Application Support" \
         -maxdepth 4 -type d \( -iname "Logs" -o -iname "DiagnosticReports" \) 2>/dev/null >> "$TMP_DIRS" || true
fi

sort -u "$TMP_DIRS" -o "$TMP_DIRS"

# 2. Batch-scan files with stat
echo -e "${YELLOW}[2/3] Scanning and measuring files...${NC}\n"

AGE_ARGS=()
[ "$MIN_AGE_DAYS" -gt 0 ] && AGE_ARGS=(-mtime "+$MIN_AGE_DAYS")

while IFS= read -r log_dir; do
    [ -d "$log_dir" ] || continue

    find "$log_dir" -type f \
        \( -name "*.log" -o -name "*.crash" -o -name "*.ips" -o -name "*.diag" -o -name "*.asl" \
           -o -name "*.gz" -o -name "*.bz2" -o -name "*.old" -o -name "*.out" -o -name "*.txt" \) \
        -size +0c ${AGE_ARGS[@]+"${AGE_ARGS[@]}"} \
        -exec stat -f $'%z\t%N' {} + 2>/dev/null >> "$TMP_RAW_LOGS" || true
done < "$TMP_DIRS"

if [ ! -s "$TMP_RAW_LOGS" ]; then
    echo -e "${GREEN}No log files found.${NC}"
    exit 0
fi

# Remove duplicates (nested Logs folders are found twice); TAB separator because paths contain spaces
sort -t $'\t' -u -k2,2 "$TMP_RAW_LOGS" | sort -t $'\t' -rn -k1,1 > "$TMP_DEDUP"

TOTAL_COUNT=$(wc -l < "$TMP_DEDUP" | tr -d ' ')
TOTAL_BYTES=$(awk -F'\t' '{sum+=$1} END {print sum+0}' "$TMP_DEDUP")

echo -e "${GREEN}Log files found: ${TOTAL_COUNT} | Total size: $(format_bytes "$TOTAL_BYTES")${NC}\n"
echo -e "${YELLOW}Largest log files:${NC}\n"

head -n "$TOP_N" "$TMP_DEDUP" | while IFS=$'\t' read -r bytes path; do
    proc_name=$(get_process_name "$path")

    if is_process_running "$proc_name"; then
        action="TRUNCATE (>)"
        status="${GREEN}Process running ($proc_name)${NC}"
    else
        action="DELETE (rm)"
        status="${YELLOW}Process not running / crash dump${NC}"
    fi

    echo -e "  ${RED}• [$(format_bytes "$bytes")]${NC} [${CYAN}${action}${NC}] $path"
    echo -e "    └── ${status}"
done

if [ "$DRY_RUN" -eq 1 ]; then
    echo -e "\n${YELLOW}Dry run: nothing was changed.${NC}"
    exit 0
fi

if [ "$ASSUME_YES" -eq 0 ]; then
    echo ""
    read -r -p "Clean all ${TOTAL_COUNT} log files? (y/N): " -n 1 REPLY
    echo ""
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "\n${YELLOW}Cancelled. No files were changed.${NC}"
        exit 0
    fi
fi

# 3. Clean up
echo -e "\n${YELLOW}[3/3] Cleaning...${NC}"
# System logs belong to root: ask for the password once, up front
grep -qE $'\t(/private/var/log|/Library/Logs)' "$TMP_DEDUP" && { sudo -v || true; }

CLEANED_BYTES=0
FAILED=0

# Read via redirection, not a pipe, otherwise the counters live in a subshell and stay 0
while IFS=$'\t' read -r bytes path; do
    [ -e "$path" ] || continue
    proc_name=$(get_process_name "$path")

    chflags nouchg,noschg "$path" 2>/dev/null || true

    if is_process_running "$proc_name"; then
        # Running process -> truncate
        if zero_file "$path"; then
            CLEANED_BYTES=$((CLEANED_BYTES + bytes))
        else
            FAILED=$((FAILED + 1))
        fi
    else
        # Finished process or crash dump -> delete
        if rm -f "$path" 2>/dev/null || sudo rm -f "$path" 2>/dev/null; then
            CLEANED_BYTES=$((CLEANED_BYTES + bytes))
        else
            FAILED=$((FAILED + 1))
        fi
    fi
done < "$TMP_DEDUP"

echo -e "\n${GREEN}Done. Freed: $(format_bytes "$CLEANED_BYTES").${NC}"
if [ "$FAILED" -gt 0 ]; then
    echo -e "${YELLOW}Could not process ${FAILED} file(s) (permissions / SIP).${NC}"
fi
