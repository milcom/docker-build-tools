#!/usr/bin/env bash

# Common script for building the Docker image through variables provided
# by Circle CI build processing.
#
# Main Parameters:
# -d - general notes for meta-data reference. Optional.
# -j - full path/application-name-prefix to stuff into the docker image
# -p - circle ci repo name or project-name.
# -V - jar version numbers. Defaults to 1.0.0
#
# Secondary Parameters (defaults if available to environment variables):
# -b - build number from circle CI. Default: CIRCLE_BUILD_NUM
# -c - github commit SHA1. Default: CIRCLE_SHA1
# -o - docker registry where the image should be stored. Default: DOCKER_REGISTRY
# -r - github repo where the source code was stored. Default: CIRCLE_REPOSITORY_URL
# -t - the final image should also be tagged as the "latest" Default: TAG_LATEST or False.
#
#   . _scripts/_build-image.sh -d "a-description" -j "path/to/jar/foo" -p "fooapp" -V "4.0.0"
#
export description="N/A"
export jar_filepath=""
export project_name=""
export version_number="1.0.0"
export build_number="${CIRCLE_BUILD_NUM}"
export github_commit="${CIRCLE_SHA1:-N/A}"
export docker_registry="${DOCKER_REGISTRY}"
export github_repo="${CIRCLE_REPOSITORY_URL}"
export tag_latest="${TAG_LATEST:-false}"

# Validate parameters.
function validate_params() {
  if [ -z description ]
  then
     echo "description is mandatory."
     return false
  fi
  if [ -z jar_filepath ]
  then
     echo "jar_filepath is mandatory."
     return false
  fi
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
  if [ -z github_commit ]
  then
     echo "github_commit is mandatory."
     return false
  fi
  if [ -z docker_registry ]
  then
     echo "docker_registry is mandatory."
     return false
  fi
  if [ -z github_repo ]
  then
     echo "github_repo is mandatory."
     return false
  fi
  if [ -z tag_latest ]
  then
     echo "tag_latest is mandatory."
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
validate_params()
if [ $? == false ]
then
  return
fi

# Construct the images tag off of the prefix and build number ex: 1.0.0-113
export docker_image_tag="${version_number}-${build_number}"

# Copy in the jar file to the temp dir so it can be placed in the image.
cp ../${jar_filepath}-${docker_image_tag}.jar  tmp/${project_name}.jar

# Create a meta-data file to stuff into the docker image.
m4 -DBUILD_NUMBER="${build_number}" \
   -DGITHUB_REPO="${github_repo}" \
   -DGITHUB_COMMIT="${github_commit}" \
   -DDESCRIPTION="${description}" \
   _templates/_meta-data.json.m4 > ./tmp/meta-data.json

# Build the image.
docker build --force-rm -t ${docker_registry}/${project_name}:${docker_image_tag} \
    --build-arg app_name="${project_name}" \
    .

# Tag it  as the latest if this is an official and final release off of master.
if [ $tag_latest == true ]
then
  docker tag ${docker_registry}/${project_name}:${docker_image_tag} \
             ${docker_registry}/${project_name}:latest
fi
