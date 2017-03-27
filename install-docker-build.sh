#!/usr/bin/env bash

# Run this command to install the docker tools into your docker directory
#
# Make sure you exclude the following in your git ignore file
# * \_scripts
# * \_tmeplates
# * \tmp
#
# First download this file
# curl -L https://github.com/milcom/docker-build-tools/install-docker-build.sh > install-docker-build.sh
# Then run it . . .
#
# Main Parameters:
# -p - path to projects docker directory ex: pat/to/project/docker
#
#   . install-docker-build.sh -d "/home/mrjohndoe/source/foo/docker"
#
export docker_directory=""

# Validate parameters.
function validate_params() {
  if [ -z docker_directory ]
  then
     echo "docker_directory is mandatory."
     return false
  fi
  return true
}

# Process Arguments.
args=`getopt d: $*`
set -- $args
for i
do
  case "$i" in
        -d) shift;docker_directory="$1";shift;;
  esac
done

# Validate variables.
validate_params()
if [ $? == false ]
then
  return
fi

# Download the package and unzip it.
curl -L https://github.com/milcom/docker-build-tools/archive/master.tar.gz > "${docker_directory}/install-docker-build.tar.gz"
tar -xvzf "${docker_directory}/install-docker-build.tar.gz" -C "${docker_directory}/"
rm -rf "${docker_directory}/install-docker-build.tar.gz"

# Create a work directory for the compile tools.
if [ ! -d "${docker_directory}/tmp" ]
 mkdir "${docker_directory}/tmp"
fi
