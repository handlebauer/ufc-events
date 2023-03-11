#!/usr/bin/env bash

# Execute the Node.js script
node $1

BASE_DIR="$(dirname "$1")/.."
LOG_FILE=/var/log/ufc-events.log

# Change to the directory one level above the script
cd $BASE_DIR

# Check if there are any changes to commit
if ! git diff-index --quiet HEAD --; then
    # Stage any modified files
    git add .

    # Commit changes with current date in commit message
    COMMIT_MESSAGE="$(date +'%Y-%m-%d') Update"
    git commit -m "$COMMIT_MESSAGE"

    # Push changes to remote repository
    git push
    echo "$(date +'%Y-%m-%d %H:%M:%S') Committed changes: $COMMIT_MESSAGE ($COMMIT_SHA)" >> $LOG_FILE
fi
    # Log that there were no changes to commit
    echo "$(date +'%Y-%m-%d %H:%M:%S') No changes to commit" >> $LOG_FILE
fi

echo "\n"
