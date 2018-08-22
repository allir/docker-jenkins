#!/bin/sh

# Check whether the following variables are set, otherwise assign default values
export DOCKER_GID=${DOCKER_GID:="999"}
export DOCKER_GROUP=${DOCKER_GROUP:="docker"}

groupmod -g ${DOCKER_GID} ${DOCKER_GROUP}

echo "Running command $@"
gosu jenkins:${DOCKER_GROUP} /usr/local/bin/jenkins.sh $@
