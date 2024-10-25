#!/bin/bash

echo "$NEW_BRANCH_NAME"
echo "${GITHUB_HEAD_REF:-${GITHUB_REF#refs/heads/}}"
