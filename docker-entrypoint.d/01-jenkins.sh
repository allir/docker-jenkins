#!/bin/sh

# Check whether the following variables are set, otherwise assign default values
: ${DOCKER_GID:="999"}
: ${DOCKER_GROUP:="docker"}

groupmod -g ${DOCKER_GID} ${DOCKER_GROUP}

