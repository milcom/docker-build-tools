#!/usr/bin/env bash

# Common script for Circle CI to use for logging into docker registry service
#
# Engineering doesn't need to modify.
#
# Environment Vars:
# DOCKER_EMAIL - backward compatibility
# DOCKER_PASS - docker registry login user password
# DOCKER_SERVER - docker URL to the server, Can sometimes be the registry
#    defaults to https://index.docker.io/v1/
# DOCKER_USER - docker registry login user id

# Login to the docker registry.
docker login -e ${DOCKER_EMAIL} -u ${DOCKER_USER} -p ${DOCKER_PASS} ${DOCKER_SERVER}
