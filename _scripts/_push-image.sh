#!/usr/bin/env bash

# Common script for Circle CI to use for pushing images into a docker registry
#  service
#
# Engineering doesn't need to modify.
#
# Environment Vars:
# CIRCLE_BUILD_NUM - build number from circle CI.
# DOCKER_REGISTRY - docker registry URL e.g. https://docker-reg.foo.com
#   or milcom if using dockerhub


# Main Parameters:
# -p - circle ci repo name or project-name.
# -V - jar version numbers. Defaults to 1.0.0
#
# Secondary Parameters (defaults if available to environment variables):
# -b - build number from circle CI. Default: CIRCLE_BUILD_NUM
# -o - docker registry where the image should be stored. Default: DOCKER_REGISTRY
#
export project_name=""
export version_number="1.0.0"
export build_number="${CIRCLE_BUILD_NUM}"
export docker_registry="${DOCKER_REGISTRY}"

# Validate parameters.
function validate_params() {
  if [ -z project_name ]
  then
     echo "project_name is mandatory."
     return false
  fi

  if [ -z version_number ]
  then
     echo "version_number is mandatory."
     return false
  fi

  if [ -z build_number ]
  then
     echo "build_number is mandatory."
     return false
  fi

  if [ -z docker_registry ]
  then
     echo "docker_registry is mandatory."
     return false
  fi

  return true
}

# Process Arguments
args=`getopt d:j:p:V:b:c:o:r:t: $*`
set -- $args
for i
do
  case "$i" in
        -p) shift;project_name="$1";shift;;
        -V) shift;version_number="$1";shift;;
        -b) shift;build_number="$1";shift;;
        -o) shift;docker_registry="$1";shift;;
  esac
done

# Validate variables
validate_params()
if [ $? == false ]
then
  return
fi

# Uploads a built images to a registry.
docker push ${docker_registry}/${project_name}:latest
docker push ${docker_registry}/${project_name}:${version_number}-${build_number}
