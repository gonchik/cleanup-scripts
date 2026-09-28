#!/usr/bin/env bash

# Delete leftover files for a removed macOS application
# Usage: ./remove_app_leftovers.sh [-n|--dry-run] [-f|--fuzzy] <AppName|BundleID> [...]
#   Example: ./remove_app_leftovers.sh Arc company.thebrowser.Browser
#
# Matches whole words of a name: "Arc" finds "Arc" and "com.foo.Arc",
# but NOT "Search" / "Archive". --fuzzy switches to plain substring matching.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() { sed -n '3,9p' "$0" | sed 's/^# \{0,1\}//'; }

DRY_RUN=0
FUZZY=0
TARGETS=()
for a in "$@"; do
    case "$a" in
        -n|--dry-run) DRY_RUN=1 ;;
        -f|--fuzzy) FUZZY=1 ;;
        -h|--help) usage; exit 0 ;;
        -*) usage; exit 1 ;;
        *) TARGETS+=("$a") ;;
    esac
done

[ ${#TARGETS[@]} -gt 0 ] || { usage; exit 1; }
for t in "${TARGETS[@]}"; do
    if [ "${#t}" -lt 3 ]; then
        echo -e "${RED}Name '${t}' is too short (min 3 characters).${NC}"; exit 1
    fi
    if [[ "$(echo "$t" | tr '[:upper:]' '[:lower:]')" == com.apple.* ]]; then
        echo -e "${RED}Apple system components (${t}) are never removed.${NC}"; exit 1
    fi
done
[ "$(uname)" = "Darwin" ] || { echo "This script is for macOS only." >&2; exit 1; }

echo -e "${BLUE}=== Searching leftovers for: ${TARGETS[*]} ===${NC}\n"

# Warn if the app is still installed or running
for t in "${TARGETS[@]}"; do
    installed=""
    if [[ "$t" == *.* ]]; then
        installed=$(mdfind "kMDItemCFBundleIdentifier == '$t'" 2>/dev/null | head -n 1 || true)
    else
        for d in /Applications "$HOME/Applications"; do
            [ -d "$d/$t.app" ] && installed="$d/$t.app"
        done
    fi
    if [ -n "$installed" ]; then
        echo -e "${YELLOW}⚠ '${t}' is still installed: ${installed}${NC}"
        echo -e "${YELLOW}  Deleting its data will reset the app's settings/profile.${NC}\n"
    fi
    if pgrep -fi "/${t}.app/" >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠ '${t}' is running, quit it before deleting.${NC}\n"
    fi
done

# Where to look (user and system level)
SEARCH_DIRS=(
    "$HOME/Library/Application Support"
    "$HOME/Library/Application Scripts"
    "$HOME/Library/Caches"
    "$HOME/Library/Preferences"
    "$HOME/Library/Saved Application State"
    "$HOME/Library/Containers"
    "$HOME/Library/Group Containers"
    "$HOME/Library/WebKit"
    "$HOME/Library/HTTPStorages"
    "$HOME/Library/Cookies"
    "$HOME/Library/Logs"
    "$HOME/Library/LaunchAgents"
    "/Library/Application Support"
    "/Library/Caches"
    "/Library/Preferences"
    "/Library/Logs"
    "/Library/LaunchAgents"
    "/Library/LaunchDaemons"
    "/Library/PrivilegedHelperTools"
)

TARGETS_JOINED=$(IFS='|'; echo "${TARGETS[*]}")
TMP_MATCHES=$(mktemp)
trap 'rm -f "$TMP_MATCHES"' EXIT

# Match entries up to depth 2 (also catches "Vendor/App"). Children of an already matched
# folder are not listed again; com.apple.* and group.com.apple.* are always skipped.
for dir in "${SEARCH_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    find "$dir" -mindepth 1 -maxdepth 2 2>/dev/null | awk \
        -v base="$dir/" -v targets="$TARGETS_JOINED" -v fuzzy="$FUZZY" '
        function norm(s) { s = tolower(s); gsub(/[._\/ -]+/, " ", s); return " " s " " }
        BEGIN { n = split(targets, T, "|"); for (i = 1; i <= n; i++) { raw[i] = tolower(T[i]); nt[i] = norm(T[i]) } }
        {
            parent = $0; sub(/\/[^\/]*$/, "", parent)
            if (parent in kept) next
            rel = substr($0, length(base) + 1); l = tolower(rel)
            if (l ~ /(^|\/)(group\.)?com\.apple\./) next
            s = norm(rel)
            for (i = 1; i <= n; i++)
                if (index(s, nt[i]) || (fuzzy == 1 && index(l, raw[i]))) { kept[$0] = 1; print; next }
        }' >> "$TMP_MATCHES" || true
done

if [ ! -s "$TMP_MATCHES" ]; then
    echo -e "${GREEN}No leftover files found.${NC}"
    [ "$FUZZY" -eq 0 ] && echo "Hint: try --fuzzy or pass the bundle ID (osascript -e 'id of app \"Name\"')."
    exit 0
fi

FOUND_ITEMS=()
SIZES=()
TOTAL_KB=0
while IFS= read -r item; do
    kb=$(du -sk "$item" 2>/dev/null | awk '{print $1}'); kb=${kb:-0}
    FOUND_ITEMS+=("$item"); SIZES+=("$kb")
    TOTAL_KB=$((TOTAL_KB + kb))
done < "$TMP_MATCHES"

human() { awk -v kb="$1" 'BEGIN{ if(kb>=1048576) printf "%.2f GB",kb/1048576; else if(kb>=1024) printf "%.1f MB",kb/1024; else printf "%d KB",kb }'; }

echo -e "${YELLOW}Found the following files and folders ($(human "$TOTAL_KB")):${NC}"
for i in "${!FOUND_ITEMS[@]}"; do
    printf "  ${RED}%2d.${NC} %9s  %s\n" "$((i + 1))" "$(human "${SIZES[$i]}")" "${FOUND_ITEMS[$i]}"
done

if [ "$DRY_RUN" -eq 1 ]; then
    echo -e "\n${YELLOW}Dry run: nothing was deleted.${NC}"; exit 0
fi

echo ""
read -r -p "Delete: [y] all, [s] select one by one, [N] cancel: " -n 1 REPLY
echo ""

delete_item() {
    local item="$1"
    [ -e "$item" ] || [ -L "$item" ] || return 0
    # Unload launch agents/daemons first, otherwise they keep running until reboot
    case "$item" in
        "$HOME"/Library/LaunchAgents/*.plist) launchctl bootout "gui/$(id -u)" "$item" 2>/dev/null || true ;;
        /Library/LaunchAgents/*.plist)        launchctl bootout "gui/$(id -u)" "$item" 2>/dev/null || true ;;
        /Library/LaunchDaemons/*.plist)       sudo launchctl bootout system "$item" 2>/dev/null || true ;;
    esac
    if rm -rf "$item" 2>/dev/null || sudo rm -rf "$item"; then
        echo -e "  ${GREEN}[Deleted]${NC} $item"
    else
        echo -e "  ${RED}[Failed]${NC} $item"
    fi
}

case "$REPLY" in
    [Yy])
        for item in "${FOUND_ITEMS[@]}"; do delete_item "$item"; done
        echo -e "\n${GREEN}Cleanup finished.${NC}"
        ;;
    [Ss])
        for item in "${FOUND_ITEMS[@]}"; do
            read -r -p "Delete $item ? (y/N): " -n 1 ans < /dev/tty; echo ""
            [[ "$ans" =~ ^[Yy]$ ]] && delete_item "$item"
        done
        echo -e "\n${GREEN}Done.${NC}"
        ;;
    *)
        echo -e "\n${YELLOW}Cancelled. No files were touched.${NC}"
        ;;
esac
