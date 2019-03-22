#!/usr/bin/env bash

set -euo pipefail

DOCKERFILE='Dockerfile'
VERSION_LINE='ARG' # Can be FROM or ARG
VERSION_REGEX='^\d\.\d+$' # REGEX Pattern for version

REPO=$(grep "^FROM" Dockerfile | head -n1 | cut -d' ' -f2 | cut -d: -f1)
if [ $VERSION_LINE == 'FROM' ]; then
	CURRENT_VERSION=$(grep FROM Dockerfile | cut -d':' -f2)
elif [ $VERSION_LINE == 'ARG' ]; then
  CURRENT_VERSION=$(grep ARG Dockerfile | cut -d'=' -f2)
else
	echo "Make sure VERSION_LINE is 'FROM' or 'ARG'"
	exit 1
fi
LATEST_VERSION=$(curl --silent --show-error https://hub.docker.com/v2/repositories/$REPO/tags/?page_size=100 | jq -r '.results|.[]|.name' | grep -P $VERSION_REGEX | sort | tail -n1)

if [ $CURRENT_VERSION != $LATEST_VERSION ]; then
	sed -i '' -e "s/\($VERSION_LINE.*\)$CURRENT_VERSION/\1$LATEST_VERSION/g" $DOCKERFILE
  git add Dockerfile && git commit -m "Update Dockerfile to build from $LATEST_VERSION"
  git push
  echo "Updated to $LATEST_VERSION"
else
  echo "Already up to date";
fi
