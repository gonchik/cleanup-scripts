#!/usr/bin/env bash
# Clear the accountPolicyData password history for every regular local user (UID >= 501).
# Fix for slow authentication: https://discussions.apple.com/thread/255702055
# Usage: ./zsh_macos_cleanup_account_data.sh [-n|--dry-run]
set -euo pipefail

[ "$(uname)" = "Darwin" ] || { echo "macOS only." >&2; exit 1; }

DRY_RUN=0
case "${1:-}" in -n|--dry-run) DRY_RUN=1 ;; esac

[ "$DRY_RUN" -eq 1 ] || sudo -v

count=0
while read -r user uid; do
    case "$user" in _*|root|daemon|nobody) continue ;; esac
    [[ "$uid" =~ ^[0-9]+$ ]] && [ "$uid" -ge 501 ] || continue

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] would clear accountPolicyData history for: $user (uid $uid)"
    else
        echo "Clearing accountPolicyData history for: $user (uid $uid)"
        sudo dscl . -deletepl "/Users/$user" accountPolicyData history \
            || echo "  (nothing to delete for $user)"
    fi
    count=$((count + 1))
done < <(dscl . -list /Users UniqueID)

echo "Done: $count regular user(s) processed."
