#!/usr/bin/env bash

set -euxo pipefail

REPO=$(grep "^FROM" Dockerfile | head -n1 | cut -d' ' -f2 | cut -d: -f1)
TAG_REGEX='^\d\.\d+$'

CURRENT_VERSION=$(grep ARG Dockerfile | cut -d'=' -f2-)
LATEST_VERSION=$(curl --silent --show-error https://hub.docker.com/v2/repositories/$REPO/tags/?page_size=100 | jq -r '.results|.[]|.name' | grep -P $TAG_REGEX | sort | tail -n1)

if [ $CURRENT_VERSION != $LATEST_VERSION ]; then
  sed -i '' -e 's/'"=$CURRENT_VERSION"'/'"=$LATEST_VERSION"'/g' Dockerfile
  git add Dockerfile && git commit -m "Update Dockerfile to build from $LATEST_VERSION"
  git push
  echo "Updated to $LATEST_VERSION"
else
  echo "Already up to date";
fi
