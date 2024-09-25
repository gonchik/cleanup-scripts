#!/bin/bash

# Get the list of all user accounts
users=$(dscl . list /Users)

# Loop through each user account and delete the accountPolicyData
for user in $users; do
    # Get the user ID for the current user
    userID=$(id -u $user 2>/dev/null)

    # Skip root, service accounts, and users with UID less than 500
    if [ "$user" != "root" ] && [ "$userID" -ge 500 ]; then
        echo "Deleting accountPolicyData for user: $user"
        sudo dscl . deletepl /Users/$user accountPolicyData history
    else
        echo "Skipping system/service account: $user"
    fi
done

echo "AccountPolicyData cleanup completed for regular users."