# MacOS cleanup
brew cleanup
gem cleanup --dryrun
gem cleanup

echo 'Cleaning up XCode Derived Data and Archives...'

rm -rf "${HOME}/Library/Caches/CocoaPods"
xcrun simctl delete unavailable
rm -rf ~/Library/Developer/Xcode/Archives
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~~/Library/Developer/Xcode/iOS Device Logs/
rm -rf ~/Library/Caches/org.carthage.CarthageKit/
echo "Cleanup done for dev caches"

echo 'Emptying the Trash 🗑 on all mounted volumes and the main HDD...'
sudo rm -rfv /Volumes/*/.Trashes/* &>/dev/null
sudo rm -rfv ~/.Trash/* &>/dev/null

echo 'Clearing System Cache Files...'
sudo rm -rfv /Library/Caches/* &>/dev/null
sudo rm -rfv /System/Library/Caches/* &>/dev/null
sudo rm -rfv ~/Library/Caches/* &>/dev/null
sudo rm -rfv /private/var/folders/bh/*/*/*/* &>/dev/null

echo 'Clearing System Log Files...'
sudo rm -rfv /private/var/log/asl/*.asl &>/dev/null
sudo rm -rfv /Library/Logs/DiagnosticReports/* &>/dev/null
sudo rm -rfv /Library/Logs/CreativeCloud/* &>/dev/null
sudo rm -rfv /Library/Logs/Adobe/* &>/dev/null
sudo rm -fv /Library/Logs/adobegc.log &>/dev/null
sudo rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/* &>/dev/null
sudo rm -rfv ~/Library/Logs/CoreSimulator/* &>/dev/null

if [ -d ~/Library/Logs/JetBrains/ ]; then
  echo 'Clearing all application log files from JetBrains...'
  rm -rfc ~/Library/Logs/JetBrains/*/ &>/dev/null
fi

if [ -d ~/Library/Application\ Support/Adobe/ ]; then
  echo 'Clearing Adobe Cache Files...'
  sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null
fi

# disables
#if [ -d ~/Library/Application\ Support/Google/Chrome/ ]; then
#  echo 'Clearing Google Chrome Cache Files...'
#  sudo rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/Application\ Cache/* &>/dev/null
# fi

echo 'Cleaning up iOS Applications...'
sudo rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null

echo 'Removing iOS Device Backups...'
sudo rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null

if type "xcrun" &>/dev/null; then
  echo 'Cleaning up iOS Simulators...'
  osascript -e 'tell application "com.apple.CoreSimulator.CoreSimulatorService" to quit' &>/dev/null
  osascript -e 'tell application "iOS Simulator" to quit' &>/dev/null
  osascript -e 'tell application "Simulator" to quit' &>/dev/null
  xcrun simctl shutdown all &>/dev/null
  xcrun simctl erase all &>/dev/null
fi

# support deleting gradle caches
if [ -d "/Users/${HOST}/.gradle/caches" ]; then
  echo 'Cleaning up Gradle cache...'
  sudo rm -rfv ~/.gradle/caches/ &>/dev/null
fi

# Function to clear DNS cache
clear_dns_cache() {
  echo "Clearing DNS cache..."
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  echo "DNS cache cleared successfully."
  echo ""
}

clear_dns_cache
