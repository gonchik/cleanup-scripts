#!/usr/bin/env bash
# Safe macOS developer cleanup.
#
# Usage: ./zsh_macos_cleanup.sh [options]
#   -n, --dry-run                  show what would be removed, change nothing
#   -y, --yes                      don't ask before emptying the Trash
#       --deep                     also remove Xcode Archives, iOS DeviceSupport,
#                                  Gradle / npm / Yarn / pip caches
#       --rust                     delete Rust target/ dirs under $HOME (depth <= 4)
#       --uninstall-android-studio remove Android Studio app and all its settings
#       --reset-password-history   clear accountPolicyData history for $USER
#                                  (slow-login fix, https://discussions.apple.com/thread/255702055)
#   -h, --help
#
# Tip: always start with --dry-run.

set -uo pipefail
shopt -s nullglob

DRY_RUN=0 ASSUME_YES=0 DEEP=0 RUST=0 UNINSTALL_AS=0 RESET_PW=0
while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1 ;;
    -y|--yes) ASSUME_YES=1 ;;
    --deep) DEEP=1 ;;
    --rust) RUST=1 ;;
    --uninstall-android-studio) UNINSTALL_AS=1 ;;
    --reset-password-history) RESET_PW=1 ;;
    -h|--help) sed -n '2,16p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1 (see --help)" >&2; exit 1 ;;
  esac
  shift
done

[ "$(uname)" = "Darwin" ] || { echo "This script is for macOS only." >&2; exit 1; }

FREED_KB=0
DATA_VOL=/System/Volumes/Data; [ -d "$DATA_VOL" ] || DATA_VOL=/

human() { awk -v kb="${1:-0}" 'BEGIN{ if(kb>=1048576) printf "%.2f GB",kb/1048576; else if(kb>=1024) printf "%.1f MB",kb/1024; else printf "%d KB",kb }'; }
section() { printf '\n\033[1;34m== %s\033[0m\n' "$1"; }
avail_kb() { df -k "$DATA_VOL" | awk 'NR==2{print $4}'; }
is_running() { pgrep -xq "$1" 2>/dev/null; }

confirm() {
  [ "$ASSUME_YES" -eq 1 ] && return 0
  local r; read -r -p "$1 [y/N] " r; [[ "$r" =~ ^[Yy]$ ]]
}

run() {
  if [ "$DRY_RUN" -eq 1 ]; then echo "  [dry-run] $*"; else "$@"; fi
}

# remove PATH... : delete files/dirs and account for their size
remove() {
  local p kb
  for p in "$@"; do
    [ -e "$p" ] || [ -L "$p" ] || continue
    kb=$(du -sk "$p" 2>/dev/null | awk '{print $1}'); kb=${kb:-0}
    FREED_KB=$((FREED_KB + kb))
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '  [dry-run] %9s  %s\n' "$(human "$kb")" "$p"
    else
      printf '  %9s  %s\n' "$(human "$kb")" "$p"
      rm -rf "$p" 2>/dev/null || echo "            ! not fully removed (permissions / in use)"
    fi
  done
}

# empty_dir DIR : delete the contents (dotfiles too), keep DIR itself
empty_dir() {
  [ -d "$1" ] || return 0
  local items=("$1"/* "$1"/.[!.]* "$1"/..?*)
  [ ${#items[@]} -gt 0 ] && remove "${items[@]}"
  return 0
}

START_KB=$(avail_kb)
[ "$DRY_RUN" -eq 1 ] && echo "*** DRY RUN: nothing will be deleted ***"

SUDO_OK=0
if [ "$DRY_RUN" -eq 0 ]; then
  echo "sudo is needed for DNS flush$( [ $RESET_PW -eq 1 ] && echo ' and password-history reset')."
  sudo -v && SUDO_OK=1 || echo "sudo unavailable, skipping sudo steps."
fi

# 1. Package managers ----------------------------------------------------------
if command -v brew >/dev/null 2>&1; then
  section "Homebrew"
  if [ "$DRY_RUN" -eq 1 ]; then
    brew cleanup --prune=all -n 2>/dev/null | tail -n 5
  else
    brew cleanup --prune=all -s || echo "  ! brew cleanup failed, continuing"
  fi
  remove "$(brew --cache)"
fi

if command -v gem >/dev/null 2>&1; then
  section "Ruby gems"
  if [ "$DRY_RUN" -eq 1 ]; then gem cleanup --dryrun 2>/dev/null | tail -n 5; else gem cleanup 2>/dev/null || true; fi
fi

# 2. Xcode, simulators, iOS -----------------------------------------------------
section "Xcode & simulators"
command -v xcrun >/dev/null 2>&1 && { run xcrun simctl delete unavailable 2>/dev/null || true; }
if is_running Xcode; then
  echo "  Xcode is running, skipping DerivedData (quit Xcode and re-run)."
else
  remove "$HOME/Library/Developer/Xcode/DerivedData"
fi
remove "$HOME/Library/Caches/CocoaPods" \
       "$HOME/Library/Caches/org.carthage.CarthageKit" \
       "$HOME/Library/Developer/Xcode/iOS Device Logs" \
       "$HOME/Library/Logs/CoreSimulator"
if [ "$DEEP" -eq 1 ]; then
  remove "$HOME/Library/Developer/Xcode/Archives" \
         "$HOME/Library/Developer/Xcode/iOS DeviceSupport" \
         "$HOME/Library/Developer/Xcode/watchOS DeviceSupport"
fi

# 3. Developer & app caches -----------------------------------------------------
section "IDE / app logs and caches"
empty_dir "$HOME/Library/Logs/JetBrains"
remove "$HOME/Library/Logs/AndroidStudio"* \
       "$HOME/Library/Logs/Google/AndroidStudio"* \
       "$HOME/Library/Caches/AndroidStudio"* \
       "$HOME/Library/Caches/Google/AndroidStudio"*
empty_dir "$HOME/Library/Application Support/Adobe/Common/Media Cache Files"

if [ "$DEEP" -eq 1 ]; then
  section "Package-manager caches (--deep)"
  if is_running java && [ -d "$HOME/.gradle/caches" ]; then
    echo "  Java/Gradle is running, skipping ~/.gradle/caches."
  else
    remove "$HOME/.gradle/caches"
  fi
  remove "$HOME/.npm/_cacache" "$HOME/Library/Caches/Yarn" "$HOME/Library/Caches/pip"
fi

# 4. Old cache files --------------------------------------------------------------
section "Files in ~/Library/Caches not modified for 7+ days"
old_kb=$(find "$HOME/Library/Caches" -type f -mtime +7 -print0 2>/dev/null \
         | xargs -0 stat -f %z 2>/dev/null | awk '{s+=$1} END{print int(s/1024)}')
old_kb=${old_kb:-0}
FREED_KB=$((FREED_KB + old_kb))
if [ "$DRY_RUN" -eq 1 ]; then
  echo "  [dry-run] $(human "$old_kb") of old cache files"
else
  find "$HOME/Library/Caches" -type f -mtime +7 -delete 2>/dev/null || true
  echo "  $(human "$old_kb") of old cache files removed"
fi

# 5. Trash ------------------------------------------------------------------------------
section "Trash"
if ! ls "$HOME/.Trash" >/dev/null 2>&1; then
  echo "  Can't read ~/.Trash: give your terminal Full Disk Access (System Settings > Privacy & Security)."
elif [ "$DRY_RUN" -eq 1 ] || confirm "  Empty the Trash?"; then
  empty_dir "$HOME/.Trash"
else
  echo "  Skipped."
fi

# 6. DNS cache --------------------------------------------------------------------------
section "DNS cache"
if [ "$DRY_RUN" -eq 1 ]; then echo "  [dry-run] flush DNS cache"
elif [ "$SUDO_OK" -eq 1 ]; then sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo "  Flushed."
fi

# Optional ------------------------------------------------------------------------------
if [ "$RUST" -eq 1 ]; then
  section "Rust target/ directories"
  while IFS= read -r -d '' t; do remove "$t"; done < <(
    find "$HOME" -maxdepth 4 \( -path "$HOME/Library" -o -path "$HOME/.Trash" \) -prune -o \
         -type d -name target -exec test -f "{}/.rustc_info.json" \; -print0 -prune 2>/dev/null)
fi

if [ "$UNINSTALL_AS" -eq 1 ]; then
  section "Uninstall Android Studio"
  if [ "$DRY_RUN" -eq 1 ] || confirm "  Completely remove Android Studio and its settings?"; then
    remove "/Applications/Android Studio.app" \
           "$HOME/Library/Preferences/AndroidStudio"* \
           "$HOME/Library/Preferences/Google/AndroidStudio"* \
           "$HOME/Library/Preferences/com.google.android."* \
           "$HOME/Library/Preferences/com.android."* \
           "$HOME/Library/Application Support/AndroidStudio"* \
           "$HOME/Library/Application Support/Google/AndroidStudio"* \
           "$HOME/.AndroidStudio"*
  fi
fi

if [ "$RESET_PW" -eq 1 ]; then
  section "Reset accountPolicyData history for $USER"
  if [ "$DRY_RUN" -eq 1 ]; then echo "  [dry-run] sudo dscl . -deletepl /Users/$USER accountPolicyData history"
  elif [ "$SUDO_OK" -eq 1 ]; then sudo dscl . -deletepl "/Users/$USER" accountPolicyData history && echo "  Done."
  fi
fi

# Report: large folders this script never touches ------------------------------------
section "Other big folders to review manually (not touched)"
for d in "$HOME/Downloads" \
         "$HOME/Library/Developer/CoreSimulator/Devices" \
         "$HOME/Library/Application Support/MobileSync/Backup" \
         "$HOME/Library/Containers/com.docker.docker" \
         "$HOME/Library/Group Containers/HUAQ24HBR6.dev.orbstack" \
         "$HOME/.m2/repository" "$HOME/go/pkg/mod" "$HOME/.cargo/registry" \
         "$HOME/.ollama/models" "$HOME/.cache/huggingface"; do
  [ -d "$d" ] || continue
  printf '  %9s  %s\n' "$(du -sh "$d" 2>/dev/null | awk '{print $1}')" "$d"
done
command -v docker >/dev/null 2>&1 && echo "  Docker: run 'docker system df' / 'docker system prune' yourself."

section "Summary"
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Would free about $(human "$FREED_KB") (not counting brew/gem). Re-run without --dry-run to clean."
else
  END_KB=$(avail_kb)
  echo "Removed about $(human "$FREED_KB"); free space: $(human "$START_KB") -> $(human "$END_KB")."
fi
