#!/usr/bin/env bash
# Completely remove Yandex Browser (and only the browser) from macOS.
# Usage: ./yandex_browser_remover.sh [-n|--dry-run] [-y|--yes]
set -uo pipefail
shopt -s nullglob

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

DRY_RUN=0 ASSUME_YES=0
for a in "$@"; do
  case "$a" in
    -n|--dry-run) DRY_RUN=1 ;;
    -y|--yes) ASSUME_YES=1 ;;
    *) echo "Usage: $0 [-n|--dry-run] [-y|--yes]" >&2; exit 1 ;;
  esac
done

[ "$(uname)" = "Darwin" ] || { echo "macOS only." >&2; exit 1; }

echo -e "${YELLOW}Searching for Yandex Browser files...${NC}"

ITEMS=()
add() { local p; for p in "$@"; do [ -e "$p" ] && ITEMS+=("$p"); done; return 0; }

# 1. Application bundles
add "/Applications/Yandex.app" "/Applications/Yandex Browser.app" "$HOME/Applications/Yandex.app"

# 2. Known browser data locations
add "$HOME/Library/Application Support/Yandex/YandexBrowser" \
    "$HOME/Library/Caches/Yandex/YandexBrowser" \
    "$HOME/Library/Logs/Yandex"

# 3. Anything with the browser bundle id / name, top level only
#    (no recursion, so other apps' containers are never touched,
#     and other Yandex apps such as Yandex Disk/Music are kept)
for dir in "Application Support" Caches Preferences "Saved Application State" \
           HTTPStorages WebKit LaunchAgents Containers "Group Containers" "Application Scripts" Cookies; do
  [ -d "$HOME/Library/$dir" ] || continue
  while IFS= read -r -d '' p; do add "$p"; done < <(
    find "$HOME/Library/$dir" -mindepth 1 -maxdepth 1 \
      \( -iname '*yandex-browser*' -o -iname '*yandex.browser*' -o -iname '*yandexbrowser*' \) -print0 2>/dev/null)
done

# Remove parent Yandex dirs only if nothing else (another Yandex app) lives there
for parent in "$HOME/Library/Application Support/Yandex" "$HOME/Library/Caches/Yandex"; do
  [ -d "$parent" ] || continue
  others=$(find "$parent" -mindepth 1 -maxdepth 1 ! -name YandexBrowser ! -name '.DS_Store' | head -n 1)
  [ -z "$others" ] && add "$parent"
done

if [ ${#ITEMS[@]} -eq 0 ]; then
  echo -e "${GREEN}No Yandex Browser files found.${NC}"; exit 0
fi

# de-duplicate (a parent may have been added after its child)
IFS=$'\n' read -r -d '' -a ITEMS < <(printf '%s\n' "${ITEMS[@]}" | sort -u; printf '\0')

echo "Found:"
for p in "${ITEMS[@]}"; do
  printf "  ${RED}•${NC} %8s  %s\n" "$(du -sh "$p" 2>/dev/null | awk '{print $1}')" "$p"
done

if [ "$DRY_RUN" -eq 1 ]; then echo -e "\n${YELLOW}Dry run: nothing deleted.${NC}"; exit 0; fi
if [ "$ASSUME_YES" -eq 0 ]; then
  read -r -p "Delete all of the above? [y/N] " r
  [[ "$r" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }
fi

echo "Closing Yandex Browser..."
osascript -e 'quit app "Yandex"' 2>/dev/null
sleep 1
pkill -f "Yandex.app/Contents" 2>/dev/null
pkill -f "Yandex Browser.app/Contents" 2>/dev/null

# Unload launch agents (updater) before deleting their plists
for p in "${ITEMS[@]}"; do
  [[ "$p" == */LaunchAgents/*.plist ]] && launchctl bootout "gui/$(id -u)" "$p" 2>/dev/null
done

for p in "${ITEMS[@]}"; do
  if rm -rf "$p" 2>/dev/null || sudo rm -rf "$p"; then echo "  Deleted: $p"; else echo "  ! Failed: $p"; fi
done

echo -e "${GREEN}Yandex Browser removed.${NC}"
