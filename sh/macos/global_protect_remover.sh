#!/usr/bin/env bash
# Completely remove Palo Alto GlobalProtect VPN client from macOS.
# Usage: ./global_protect_remover.sh [-n|--dry-run] [-y|--yes]
set -uo pipefail
shopt -s nullglob

DRY_RUN=0 ASSUME_YES=0
for a in "$@"; do
  case "$a" in
    -n|--dry-run) DRY_RUN=1 ;;
    -y|--yes) ASSUME_YES=1 ;;
    *) echo "Usage: $0 [-n|--dry-run] [-y|--yes]" >&2; exit 1 ;;
  esac
done

[ "$(uname)" = "Darwin" ] || { echo "macOS only." >&2; exit 1; }

run() { if [ "$DRY_RUN" -eq 1 ]; then echo "  [dry-run] $*"; else "$@"; fi; }

SYS_PATHS=(
  /Applications/GlobalProtect.app
  /Library/LaunchDaemons/com.paloaltonetworks.gp.pangps.plist
  /Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist
  "/Library/Application Support/PaloAltoNetworks"
  /Library/Logs/PaloAltoNetworks
  /Library/Preferences/com.paloaltonetworks.GlobalProtect*
)
USER_PATHS=(
  "$HOME/Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist"
  "$HOME/Library/Application Support/PaloAltoNetworks"
  "$HOME/Library/Caches/com.paloaltonetworks.GlobalProtect"*
  "$HOME/Library/Logs/PaloAltoNetworks"
  "$HOME/Library/Preferences/com.paloaltonetworks.GlobalProtect"*
  "$HOME/Library/Saved Application State/com.paloaltonetworks.GlobalProtect.savedState"
  "$HOME/Library/HTTPStorages/com.paloaltonetworks.GlobalProtect"*
)

echo "==> GlobalProtect items found:"
found=0
for p in "${SYS_PATHS[@]}" "${USER_PATHS[@]}"; do
  [ -e "$p" ] && { echo "  $p"; found=1; }
done
[ "$found" -eq 0 ] && echo "  (no files; will still stop services and clean network state)"

if [ "$DRY_RUN" -eq 0 ] && [ "$ASSUME_YES" -eq 0 ]; then
  read -r -p "Remove GlobalProtect completely? [y/N] " r
  [[ "$r" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }
fi
[ "$DRY_RUN" -eq 1 ] || sudo -v || exit 1

echo "==> Stopping GlobalProtect services..."
# Daemon lives in the system domain, the agent in the user's GUI domain.
run sudo launchctl bootout system /Library/LaunchDaemons/com.paloaltonetworks.gp.pangps.plist 2>/dev/null
run launchctl bootout "gui/$(id -u)" /Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist 2>/dev/null
run launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist" 2>/dev/null

echo "==> Terminating running processes..."
run sudo killall -9 GlobalProtect PanGPS PanGPA 2>/dev/null

# The vendor uninstaller also removes the login plugin / authorization entries,
# which must NOT be deleted by hand (can break the login window).
UNINSTALLER=/Applications/GlobalProtect.app/Contents/Resources/uninstall_gp.sh
if [ -f "$UNINSTALLER" ]; then
  echo "==> Running vendor uninstaller..."
  run sudo "$UNINSTALLER"
fi

echo "==> Removing remaining files..."
for p in "${SYS_PATHS[@]}"; do [ -e "$p" ] && run sudo rm -rf "$p"; done
for p in "${USER_PATHS[@]}"; do [ -e "$p" ] && run rm -rf "$p"; done

echo "==> Forgetting installer receipts..."
for pkg in $(pkgutil --pkgs | grep -i paloaltonetworks); do run sudo pkgutil --forget "$pkg"; done

echo "==> Cleaning network state..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "  [dry-run] scutil: remove State:/Network/Service/gpd.pan/{IPv4,DNS}"
else
  sudo scutil <<'SC'
remove State:/Network/Service/gpd.pan/IPv4
remove State:/Network/Service/gpd.pan/DNS
quit
SC
fi
run sudo dscacheutil -flushcache
run sudo killall -HUP mDNSResponder

if systemextensionsctl list 2>/dev/null | grep -qi paloalto; then
  echo "!! A GlobalProtect system extension is still registered."
  echo "   Remove it in System Settings > General > Login Items & Extensions > Network Extensions, then reboot."
fi

echo "==> GlobalProtect removal finished. A reboot is recommended."
