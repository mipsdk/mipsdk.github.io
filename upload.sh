#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

if [[ -n "$(git status --porcelain)" ]]; then
    echo "There are file changes (modified, added, or deleted)"
else
    echo "No file changes detected"
    exit 0
fi

echo "Upload script start to execute ..."

$SCRIPT_DIR/config/file_list.sh

WORKDIR=$(pwd)

echo "WORKDIR = $WORKDIR"

REMOTE_URL=$(git remote get-url origin)

echo "REMOTE_URL = $REMOTE_URL"

echo "WEB_PAGE = https://mipsdk.github.io"

BRANCH=$(git branch)

echo "BRANCH = $BRANCH"

git status --porcelain

git add .

git commit -m "1. upload maven files"

echo "push $BRANCH -> $REMOTE_URL"

git push -u origin HEAD

echo "Upload script execute over ..."