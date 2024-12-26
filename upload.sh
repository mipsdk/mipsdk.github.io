#!/bin/bash

echo "Upload script start to execute ..."

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

$SCRIPT_DIR/config/file_list.sh

WORKDIR=$(pwd)

echo "WORKDIR = $WORKDIR"

REMOTE_URL=$(git remote get-url origin)

echo "REMOTE_URL = $REMOTE_URL"

echo "WEB_PAGE = https://mipsdk.github.io"

BRANCH=$(git branch)

echo "BRANCH = $BRANCH"

git add .

git commit -m "1. upload maven files"

echo "push $BRANCH -> $REMOTE_URL"

git push -u origin master

echo "Upload script execute over ..."