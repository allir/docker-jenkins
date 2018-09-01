#!/bin/sh

DIR=/etc/docker-entrypoint.d

if [ -d "$DIR" ]
then
  echo "Found docker-entrypoint dir, running scripts in $DIR"
  ## Alpine doesn't support verbose and regex flags
  #/bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
  /bin/run-parts "$DIR"
fi

exec gosu "$@"
