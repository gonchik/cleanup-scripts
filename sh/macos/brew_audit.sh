#!/usr/bin/env bash
#
# brew_audit.sh - audit Homebrew packages, casks, disk usage and health.
#
# Usage: ./brew_audit.sh [--fix] [-h|--help]
#   (default)  read-only report
#   --fix      after the report, offer to run: brew upgrade, brew autoremove, brew cleanup

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

FIX=0
case "${1:-}" in
    "") ;;
    --fix) FIX=1 ;;
    -h|--help) sed -n '3,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1 (see --help)" >&2; exit 1 ;;
esac

print_header() { echo -e "\n${BLUE}${BOLD}=== $1 ===${NC}"; }
indent() { sed 's/^/  - /'; }
confirm() { local r; read -r -p "$1 [y/N] " r; [[ "$r" =~ ^[Yy]$ ]]; }

if ! command -v brew &>/dev/null; then
    echo -e "${RED}Error: Homebrew is not installed or not in PATH.${NC}" >&2
    exit 1
fi

echo -e "${GREEN}${BOLD}Starting Homebrew audit...${NC}"

# 1. Package counts
print_header "Overview"
FORMULAE_COUNT=$(brew list --formula 2>/dev/null | wc -l | tr -d ' ')
CASKS_COUNT=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
LEAVES_COUNT=$(brew leaves 2>/dev/null | wc -l | tr -d ' ')
PINNED_COUNT=$(brew list --pinned 2>/dev/null | wc -l | tr -d ' ')

echo "Top-level formulae (leaves) : ${LEAVES_COUNT}"
echo "Total formulae (incl. deps) : ${FORMULAE_COUNT}"
echo "Casks (GUI apps)            : ${CASKS_COUNT}"
echo "Pinned                      : ${PINNED_COUNT}"

# 2. Outdated packages
print_header "Outdated packages"
OUTDATED_FORMULAE=$(brew outdated --formula 2>/dev/null || true)
OUTDATED_CASKS=$(brew outdated --cask --greedy-auto-updates 2>/dev/null || true)

if [[ -n "${OUTDATED_FORMULAE}" ]]; then
    echo -e "${YELLOW}Outdated formulae:${NC}"
    echo "${OUTDATED_FORMULAE}" | indent
else
    echo -e "${GREEN}✓ All formulae are up to date.${NC}"
fi

if [[ -n "${OUTDATED_CASKS}" ]]; then
    echo -e "\n${YELLOW}Outdated casks:${NC}"
    echo "${OUTDATED_CASKS}" | indent
else
    echo -e "${GREEN}✓ All casks are up to date.${NC}"
fi

# 3. Pinned packages
if [[ "${PINNED_COUNT}" -gt 0 ]]; then
    print_header "Pinned packages (skipped by brew upgrade)"
    brew list --pinned 2>/dev/null | indent
fi

# 4. Orphaned dependencies.
# `brew autoremove --dry-run` prints "==> Would autoremove N unneeded formulae:" followed by one name per line.
print_header "Orphaned dependencies"
ORPHANS=$(brew autoremove --dry-run 2>/dev/null | sed -n '/^==> Would autoremove/,$p' | sed '1d' || true)
if [[ -n "${ORPHANS}" ]]; then
    echo -e "${YELLOW}No longer required by any installed package:${NC}"
    echo "${ORPHANS}" | indent
else
    echo -e "${GREEN}✓ No orphaned dependencies.${NC}"
fi

# 5. Unlinked packages
print_header "Unlinked kegs"
UNLINKED=$(brew list --formula --unlinked 2>/dev/null || true)
if [[ -n "${UNLINKED}" ]]; then
    echo -e "${YELLOW}Installed but not linked into PATH (often keg-only, usually fine):${NC}"
    echo "${UNLINKED}" | indent
else
    echo -e "${GREEN}✓ No unlinked kegs.${NC}"
fi

# 6. Disk usage
print_header "Disk usage"
CELLAR_PATH=$(brew --cellar 2>/dev/null || true)
CACHE_PATH=$(brew --cache 2>/dev/null || true)
[[ -d "${CELLAR_PATH}" ]] && echo "Cellar : $(du -sh "${CELLAR_PATH}" 2>/dev/null | awk '{print $1}')  (${CELLAR_PATH})"
[[ -d "${CACHE_PATH}"  ]] && echo "Cache  : $(du -sh "${CACHE_PATH}"  2>/dev/null | awk '{print $1}')  (${CACHE_PATH})"

if [[ -d "${CELLAR_PATH}" ]]; then
    echo -e "\n${BOLD}Top 10 largest formulae:${NC}"
    du -sk "${CELLAR_PATH}"/* 2>/dev/null | sort -rn | head -n 10 | while IFS=$'\t' read -r kb path; do
        printf "  - %8s  %s\n" "$(awk -v k="$kb" 'BEGIN{ if(k>=1048576) printf "%.1fG",k/1048576; else printf "%.0fM",k/1024 }')" "$(basename "$path")"
    done || true
fi

if [[ "${CASKS_COUNT}" -gt 0 ]]; then
    echo -e "\n${BOLD}Top 10 largest casks (installed apps):${NC}"
    CASKROOM="$(brew --prefix)/Caskroom"
    # One brew call for all casks: prints "<cask>\t<app name>" (app may be empty for non-app casks)
    brew info --cask --installed --json=v2 2>/dev/null | python3 -c '
import json, sys
for c in json.load(sys.stdin).get("casks", []):
    apps = [x if isinstance(x, str) else x.get("target", "")
            for a in c.get("artifacts", []) if isinstance(a, dict) for x in a.get("app", [])]
    for app in apps or [""]:
        print(c["token"] + "\t" + app)
' | while IFS=$'\t' read -r cask app; do
        if [[ -n "$app" && -d "/Applications/$app" ]]; then
            kb=$(du -sk "/Applications/$app" 2>/dev/null | awk '{print $1}')
        else
            kb=$(du -sk "$CASKROOM/$cask" 2>/dev/null | awk '{print $1}')
        fi
        printf "%s\t%s\n" "${kb:-0}" "$cask"
    done | sort -rn | head -n 10 | while IFS=$'\t' read -r kb cask; do
        printf "  - %8s  %s\n" "$(awk -v k="$kb" 'BEGIN{ if(k>=1048576) printf "%.1fG",k/1048576; else printf "%.0fM",k/1024 }')" "$cask"
    done || true
fi

# 7. Health check
print_header "brew doctor"
DOCTOR_OUTPUT=$(brew doctor 2>&1 || true)
if echo "${DOCTOR_OUTPUT}" | grep -q "Your system is ready to brew."; then
    echo -e "${GREEN}✓ Your system is ready to brew.${NC}"
else
    echo -e "${YELLOW}Warnings reported by 'brew doctor':${NC}"
    echo "${DOCTOR_OUTPUT}" | head -n 15 | sed 's/^/  /'
    if [[ $(echo "${DOCTOR_OUTPUT}" | wc -l) -gt 15 ]]; then
        echo -e "  ${BLUE}... (run 'brew doctor' to see everything)${NC}"
    fi
fi

# 8. Recommendations / fixes
if [[ "$FIX" -eq 0 ]]; then
    print_header "Recommendations"
    echo "  • Upgrade outdated packages: brew upgrade"
    echo "  • Remove orphaned deps:      brew autoremove"
    echo "  • Purge old downloads:       brew cleanup --prune=all -s"
    echo "  • Or re-run with --fix to do these interactively."
    exit 0
fi

print_header "Fix"
if [[ -n "${OUTDATED_FORMULAE}${OUTDATED_CASKS}" ]] && confirm "Run 'brew upgrade'?"; then
    brew upgrade || echo -e "${RED}brew upgrade reported errors.${NC}"
fi
if [[ -n "${ORPHANS}" ]] && confirm "Remove orphaned dependencies (brew autoremove)?"; then
    brew autoremove
fi
if confirm "Run 'brew cleanup --prune=all -s'?"; then
    brew cleanup --prune=all -s
fi
echo -e "${GREEN}Done.${NC}"
