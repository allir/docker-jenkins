#!/bin/sh

# Check whether the following variables are set, otherwise assign default values
: ${DOCKER_UID:="1000"}
: ${DOCKER_GID:="999"}
: ${DOCKER_GROUP:="docker"}

usermod -u ${DOCKER_UID} -aG ${DOCKER_GROUP} jenkins
groupmod -g ${DOCKER_GID} ${DOCKER_GROUP}

