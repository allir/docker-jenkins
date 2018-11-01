#!/bin/sh
set -e

DIR=/docker-entrypoint.d
if [ -d "$DIR" ]
then
  /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
fi

exec "$@"

