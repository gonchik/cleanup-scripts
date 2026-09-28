#!/usr/bin/env bash

# Fast, read-only finder for leftovers of uninstalled macOS apps.
# Usage: ./find_uninstalled_apps.sh   (nothing is deleted; use remove_app_leftovers.sh for that)
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Searching leftovers of uninstalled apps ===${NC}\n"

TMP_APPS=$(mktemp)
TMP_LEFTOVERS=$(mktemp)
TMP_PLISTS=$(mktemp)
trap 'rm -f "$TMP_APPS" "$TMP_LEFTOVERS" "$TMP_PLISTS"' EXIT

# 1. Index installed .app bundles and their bundle IDs
echo -e "${YELLOW}[1/4] Indexing installed applications...${NC}"

find /Applications ~/Applications /System/Applications /System/Library/CoreServices -maxdepth 3 -name "*.app" 2>/dev/null | while IFS= read -r app_path; do
    app_name=$(basename "$app_path" .app)
    echo "$app_name" >> "$TMP_APPS"

    plist_path="$app_path/Contents/Info.plist"
    if [ -f "$plist_path" ]; then
        bundle_id=$(plutil -extract CFBundleIdentifier raw "$plist_path" 2>/dev/null || true)
        if [ -n "$bundle_id" ] && [[ "$bundle_id" != *"Command line utility"* ]]; then
            echo "$bundle_id" >> "$TMP_APPS"
        fi
    fi
done

tr '[:upper:]' '[:lower:]' < "$TMP_APPS" | sort -u > "${TMP_APPS}.clean"
mv "${TMP_APPS}.clean" "$TMP_APPS"

format_kb() {
    local kb=$1
    awk -v kb="$kb" 'BEGIN {
        if (kb >= 1048576) printf "%.2f GB", kb/1048576;
        else if (kb >= 1024) printf "%.2f MB", kb/1024;
        else printf "%d KB", kb;
    }'
}

# Size measurement with a 3-second timeout (du can hang on huge/cloud folders)
get_size_kb() {
    local target_path="$1"
    local tmp_du
    tmp_du=$(mktemp)

    ( du -sk "$target_path" 2>/dev/null > "$tmp_du" ) &
    local pid=$!
    local count=0

    while kill -0 "$pid" 2>/dev/null; do
        sleep 0.1
        count=$((count + 1))
        if [ "$count" -gt 30 ]; then # 3 seconds max
            kill -9 "$pid" 2>/dev/null || true
            wait "$pid" 2>/dev/null || true
            rm -f "$tmp_du"
            echo "0"
            return
        fi
    done

    wait "$pid" 2>/dev/null || true
    if [ -s "$tmp_du" ]; then
        awk '{print $1}' "$tmp_du"
    else
        echo "0"
    fi
    rm -f "$tmp_du"
}

is_system_or_apple() {
    local lower_name
    lower_name=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    case "$lower_name" in
        com.apple.*|addressbook|callhistory*|mobilesync|clouddocs|knowledge|safari|siri|suggestions|metadata|crashreporter|logs|caches|accountnotification|fileprovider|routined|symptoms|icloud*|dvdplayer|dock|ihtmleditor)
            return 0
            ;;
    esac
    return 1
}

is_app_installed() {
    local target="$1"
    local lower_target
    lower_target=$(echo "$target" | tr '[:upper:]' '[:lower:]')

    # 1. Direct match
    if grep -q -i -F -- "$lower_target" "$TMP_APPS"; then
        return 0
    fi

    # 1b. An installed CLI tool (brew, pip, npm -g ...) with this name
    if command -v "$lower_target" >/dev/null 2>&1; then
        return 0
    fi

    # 2. Strip vendor suffixes (BraveSoftware -> Brave, TelegramDesktop -> Telegram)
    local cleaned
    cleaned=$(echo "$target" | sed -E 's/(Software|Desktop|App|Inc|Corp|Group|Launcher|Client)$//i' | tr '[:upper:]' '[:lower:]')
    if [ -n "$cleaned" ] && [ "${#cleaned}" -ge 3 ]; then
        if grep -q -i -F -- "$cleaned" "$TMP_APPS"; then
            return 0
        fi
    fi

    # 3. Split CamelCase and compound words
    for word in $(echo "$target" | sed -E 's/([a-z])([A-Z])/\1 \2/g' | tr '._-' ' '); do
        local w_lower
        w_lower=$(echo "$word" | tr '[:upper:]' '[:lower:]')
        if [ "${#w_lower}" -ge 4 ]; then
            if grep -q -i -F -- "$w_lower" "$TMP_APPS"; then
                return 0
            fi
        fi
    done

    return 1
}

# 2. Scan Application Support and Containers
echo -e "${YELLOW}[2/4] Scanning Application Support and Containers...${NC}"

SEARCH_PATHS=(
    "$HOME/Library/Application Support"
    "$HOME/Library/Containers"
)

for search_dir in "${SEARCH_PATHS[@]}"; do
    if [ -d "$search_dir" ]; then
        for path in "$search_dir"/*; do
            [ -e "$path" ] || continue
            name=$(basename "$path")

            is_system_or_apple "$name" && continue

            if ! is_app_installed "$name"; then
                echo -ne "\r\033[K  Checking: $name"

                kb=$(get_size_kb "$path")
                if [ -n "$kb" ] && [ "$kb" -gt 0 ]; then
                    echo -e "${kb}\t${path}" >> "$TMP_LEFTOVERS"
                fi
            fi
        done
    fi
done

echo -ne "\r\033[K"

if [ -s "$TMP_LEFTOVERS" ]; then
    echo -e "${GREEN}Leftovers of uninstalled apps (largest first):${NC}"
    sort -rn -k1,1 "$TMP_LEFTOVERS" | while IFS=$'\t' read -r kb path; do
        size_str=$(format_kb "$kb")
        echo -e "  ${RED}• [${size_str}]${NC} $path"
    done
else
    echo "  No leftover folders found."
fi

# 3. Scan Preferences
echo -e "\n${YELLOW}[3/4] Scanning preferences (~/Library/Preferences)...${NC}"
if [ -d "$HOME/Library/Preferences" ]; then
    find "$HOME/Library/Preferences" -maxdepth 1 -name "*.plist" 2>/dev/null | while IFS= read -r plist; do
        filename=$(basename "$plist" .plist)
        is_system_or_apple "$filename" && continue

        if ! is_app_installed "$filename"; then
            kb=$(get_size_kb "$plist")
            [ -n "$kb" ] && [ "$kb" -gt 0 ] && echo -e "${kb}\t${plist}" >> "$TMP_PLISTS"
        fi
    done

    if [ -s "$TMP_PLISTS" ]; then
        sort -rn -k1,1 "$TMP_PLISTS" | head -n 15 | while IFS=$'\t' read -r kb path; do
            size_str=$(format_kb "$kb")
            echo -e "  ${RED}• [${size_str}]${NC} $(basename "$path")"
        done
    else
        echo "  No leftover plist files found."
    fi
fi

# 4. Orphaned launch agents/daemons: the program is gone,
#    but launchd keeps trying to start it
echo -e "\n${YELLOW}[4/4] Launch agents/daemons whose program is missing...${NC}"
orphans=0
for plist in "$HOME"/Library/LaunchAgents/*.plist /Library/LaunchAgents/*.plist /Library/LaunchDaemons/*.plist; do
    [ -f "$plist" ] || continue
    label=$(basename "$plist" .plist)
    is_system_or_apple "$label" && continue
    prog=$(plutil -extract Program raw "$plist" 2>/dev/null || plutil -extract ProgramArguments.0 raw "$plist" 2>/dev/null || true)
    [ -n "$prog" ] || continue
    prog="${prog/#\~/$HOME}"
    # relative names (e.g. "bash", "node") are looked up in PATH
    if [[ "$prog" != /* ]]; then command -v "$prog" >/dev/null 2>&1 && continue; fi
    if [ ! -e "$prog" ]; then
        echo -e "  ${RED}•${NC} $plist"
        echo -e "    └── missing: $prog"
        orphans=$((orphans + 1))
    fi
done
[ "$orphans" -eq 0 ] && echo "  No orphaned launch agents found."

echo -e "\n${GREEN}Scan finished.${NC}"
echo -e "To remove an app's leftovers: ${BLUE}./remove_app_leftovers.sh -n <Name|BundleID>${NC} (then again without -n)"