#!/bin/sh
set -e

DIR=/docker-entrypoint.d
if [ -d "$DIR" ]
then
  echo "Running scripts in $DIR"
  ## Alpine doesn't support verbose and regex flags
  #/bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
  /bin/run-parts "$DIR"
fi

exec "$@"

