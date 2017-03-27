#!/usr/bin/env bash

# This script can be used by developers to create their own personal images.
#
# environment variables should be set:
#
# DOCKER_USER - your unix login name such as lnijinsky, dlewis etc,
# something short that identifies you for your builds in the repository.
#
#  ex: export DOCKER_USER=lnijinsky
#
# build-local-image.sh -p <project> -V <version> [optional options]
#
# Some optional parameters you may want to set for meta-data purposes,
# but not required because it's an engineering build:
#
# -c - github commit SHA1
# -d - general notes for meta-data reference.
#
# 1) Place your JAR file in docker/tmp
# 2) Run this script from docker/
#
# ex minimum needed and the usual pattern for most purposes:
# . _scripts/_build-local-image.sh -p "foo-mobile" -V "4.0.0"
# ex maximum normally:
# . _scripts/_build-local-image.sh -p "foo-mobile" -V "4.0.0" -c "sha1-2347" -d "Some Notes"
#
# Other parameters are available but normally aren't set. See getopt below
# for those parsed variables.
#

export TIMESTAMP=`date +%Y%m%d%H%M%S`
export description="N/A"
export jar_filepath="dummy_param"
export project_name=""
export version_number="1.0.0"
export build_number="${DOCKER_USER}"
export github_commit="N/A"
export docker_registry="milcom"
export github_repo="N/A"
export tag_latest=false

# Validate parameters.
function validate_params() {
  if [ -z ${DOCKER_USER} ]
  then
    echo "environment var DOCKER_USER must be set to your user name ex: lnijynsky"
    return 0
  fi

  if [ -z $description ]
  then
     echo "description is mandatory."
     return 0
  fi

  if [ -z $jar_filepath ]
  then
     echo "jar_filepath is mandatory."
     return 0
  fi

  if [ -z $project_name ]
  then
     echo "project_name is mandatory."
     return 0
  fi

  if [ -z $version_number ]
  then
     echo "version_number is mandatory."
     return 0
  fi

  if [ -z $build_number ]
  then
     echo "build_number is mandatory."
     return 0
  fi

  if [ -z $github_commit ]
  then
     echo "github_commit is mandatory."
     return 0
  fi

  if [ -z $docker_registry ]
  then
     echo "docker_registry is mandatory."
     return 0
  fi

  if [ -z $github_repo ]
  then
     echo "github_repo is mandatory."
     return 0
  fi

  if [ -z $tag_latest ]
  then
     echo "tag_latest is mandatory."
     return 0
  fi

  return 1
}

# Process Arguments
args=`getopt d:j:p:V:b:c:o:r:t: $*`
set -- $args
for i
do
  case "$i" in
        -d) shift;description="$1";shift;;
        -j) shift;jar_filepath="$1";shift;;
        -p) shift;project_name="$1";shift;;
        -V) shift;version_number="$1";shift;;
        -b) shift;build_number="$1";shift;;
        -c) shift;github_commit="$1";shift;;
        -o) shift;docker_registry="$1";shift;;
        -r) shift;github_repo="$1";shift;;
        -t) shift;tag_latest="$1";shift;;
  esac
done

# Validate variables
validate_params
if [ $? == 0 ]
then
  return
fi

# Run the build script
. _scripts/_build-image.sh  \
  -d $description \
  -j $jar_filepath \
  -p $project_name \
  -V $version_number \
  -b "dev-${build_number}" \
  -c $github_commit \
  -o $docker_registry \
  -r $github_repo \
  -t $tag_latest
