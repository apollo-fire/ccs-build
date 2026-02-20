#!/bin/bash
# $1 template path
# $2 output path

GITHUB_SHA_SHORT="$(git rev-parse HEAD | cut -c1-8)"
echo "$GITHUB_SHA_SHORT"
