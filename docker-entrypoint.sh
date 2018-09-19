#!/bin/sh

DIR=/etc/docker-entrypoint.d

if [ -d "$DIR" ]
then
  echo "Found docker-entrypoint dir, running scripts in $DIR"
  /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
fi

exec gosu "jenkins:${DOCKER_GROUP}" "$@"
