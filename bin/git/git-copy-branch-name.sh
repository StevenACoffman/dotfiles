#!/bin/sh
#
# Copy the current branch name to the clipboard.

branch=$(git rev-parse --abbrev-ref HEAD)
echo "Copying $branch to clipboard"
echo "$branch" | tr -d '\n' | tr -d ' ' | pbcopy
