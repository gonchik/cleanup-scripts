#!/usr/bin/env bash
# Safe macOS Developer Cleanup Script

set -e

echo '=== Starting Safe macOS Cleanup ==='

# 1. Package Managers
if command -v brew &>/dev/null; then
  echo 'Cleaning Homebrew caches and old versions...'
  brew cleanup -s
  rm -rf "$(brew --cache)"
fi

if command -v gem &>/dev/null; then
  echo 'Cleaning Ruby Gems...'
  gem cleanup 2>/dev/null || true
fi

# 2. Xcode, Simulators, and iOS Caches
if command -v xcrun &>/dev/null; then
  echo 'Cleaning Xcode Derived Data, Archives, and Simulator Caches...'
  xcrun simctl delete unavailable 2>/dev/null || true
  rm -rf "${HOME}/Library/Caches/CocoaPods"
  rm -rf "${HOME}/Library/Caches/org.carthage.CarthageKit"
  rm -rf "${HOME}/Library/Developer/Xcode/DerivedData"
  rm -rf "${HOME}/Library/Developer/Xcode/Archives"
  rm -rf "${HOME}/Library/Developer/Xcode/iOS Device Logs"
  rm -rf "${HOME}/Library/Logs/CoreSimulator"
fi

# 3. Developer & App Caches
echo 'Clearing application logs and build caches...'
rm -rf "${HOME}/Library/Logs/JetBrains"/* 2>/dev/null
rm -rf "${HOME}/Library/Logs/AndroidStudio"* 2>/dev/null
rm -rf "${HOME}/Library/Logs/Google/AndroidStudio"* 2>/dev/null
rm -rf "${HOME}/Library/Caches/AndroidStudio"* 2>/dev/null
rm -rf "${HOME}/Library/Caches/Google/AndroidStudio"* 2>/dev/null

if [ -d "${HOME}/Library/Application Support/Adobe" ]; then
  echo 'Clearing Adobe Media Cache Files...'
  rm -rf "${HOME}/Library/Application Support/Adobe/Common/Media Cache Files"/* 2>/dev/null
fi

if [ -d "${HOME}/.gradle/caches" ]; then
  echo 'Cleaning Gradle Cache...'
  rm -rf "${HOME}/.gradle/caches"
fi

# 4. User Trash & Old Cache Files
echo 'Emptying Trash...'
rm -rf "${HOME}/.Trash"/* 2>/dev/null

echo 'Removing user cache items older than 7 days...'
find "${HOME}/Library/Caches" -mindepth 1 -maxdepth 2 -mtime +7 -exec rm -rf {} + 2>/dev/null || true

# 5. Flush DNS Cache
echo 'Flushing DNS Cache...'
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo '=== Standard Cleanup Complete! ==='

# ------------------------------------------------------------------------------
# OPTIONAL / DESTRUCTIVE FUNCTIONS
# (Uncomment below to run specific deep cleanups)
# ------------------------------------------------------------------------------

clean_rust_targets() {
  echo "Deleting Rust 'target' build directories across projects..."
  find "${HOME}" -maxdepth 4 -type d -name "target" -exec test -f "{}/.rustc_info.json" \; -print -exec rm -rf "{}" + 2>/dev/null
}

uninstall_android_studio_completely() {
  echo "WARNING: Completely uninstalling Android Studio application and settings..."
  rm -rf /Applications/Android\ Studio.app
  rm -rf "${HOME}/Library/Preferences/AndroidStudio"*
  rm -rf "${HOME}/Library/Preferences/Google/AndroidStudio"*
  rm -rf "${HOME}/Library/Preferences/com.google.android."*
  rm -rf "${HOME}/Library/Preferences/com.android."*
  rm -rf "${HOME}/Library/Application Support/AndroidStudio"*
  rm -rf "${HOME}/Library/Application Support/Google/AndroidStudio"*
  rm -rf "${HOME}/.AndroidStudio"*
}

# To execute optional functions, uncomment the lines below:
# clean_rust_targets
# uninstall_android_studio_completely

# problem slow auth
# https://discussions.apple.com/thread/255702055?login=true&sortBy=rank&page=1
sudo dscl . deletepl /Users/`whoami` accountPolicyData history
