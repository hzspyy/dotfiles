#!/usr/bin/env bash

FILE="$1"
# Find how many commits ago the file was added
COMMITS_AGO=$(git log --oneline --diff-filter=A -- "$FILE" | wc -l)

if [ "$COMMITS_AGO" -eq 0 ]; then
    echo "File not found in history"
    exit 1
fi

# Remove the file
git rm --cached "$FILE" 2>/dev/null || true
# Fixup into the commit that added it
git commit --fixup "HEAD~$((COMMITS_AGO-1))"
# Auto-squash rebase
GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "HEAD~$COMMITS_AGO"