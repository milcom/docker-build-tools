### Helper Scripts for Circle CI to use for the Docker Build, Login, and Push

Code in this directory doesn't normally need to be edited by engineering for
application needs.

This directory contains helper scripts for creating the docker file and
pushing it to the registry.

\_build-local-image.sh can be used by an engineer.

The rest should only be used by Circle CI.

- \_build-image.sh - this script reads the environment variables, copies the JAR
file to the docker/tmp directory, creates the meta-data-json, and builds the
image with the Dockerfile. It then tags the image as latest. Do not modify.

- \_build-local-image.sh - this script can be used by an engineer to create their
own test docker image for local testing. Since images are named unique to the engineer.

- \_docker-login.sh - signs into the docker registry using the environment variables.

- \_push-image.sh - uploads the docker images to the registry.

### Engineering build and testing.

You can create your own uniquely named images using the following provided
script and instructions. These images can safely be pushed to dockerhub without
conflict to official builds.

```
# Export your unix name into an environment variable

export DOCKER_USER=foomanbar

# Place your JAR file in /tmp

cp foo.jar tmp/foo.jar

#  Run this script from /docker
# . _scripts/_build-local-image.sh -p "foo" -V "4.0.0" -c "commitsomeSHA1" -d "Some Notes"

. _scripts/_build-local-image.sh -p "foo" -V "4.0.0" 
```

#### Extracting metadata from the image.

We copy all metadata into the image during the build so it can be referenced later as needed.

The standard place should always be /etc/docker/metadata/ in the image.

To pull the metadata later, you can use the following commands to get the
metadata.

The temp container created below is only created for file extraction and is
never run:
```
# First we extract out the files.
export cid=$(docker create <image-name>)
docker cp $cid:/etc/docker/metadata/ - > docker-metadata-$cid.tar
docker rm -v $cid
mkdir docker-metadata-$cid
tar -xf docker-metadata-$cid.tar -C docker-metadata-$cid --strip-components=1
cd docker-metadata-$cid

# Finally, we can clean up the work area.
rm -rf docker-metadata-$cid
rm docker-metadata-$cid.tar
unset cid
etc...
```
NOTE: To run the tar command on MacOS, you need to install the alternate
version since docker is finicky on GNU versions:
```
brew install gnu-tar
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
```
