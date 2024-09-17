#!/bin/bash

# =======================================================================================
# Build Docker image
#
# This scripts builds the Docker image, and add image name with tags #1 and #2 as set in
# param script
#
# Arguments:
#   #1: if "noproxy", build image without HTTP proxy env vars
# =======================================================================================

# ------------------------------------------------------
# Import parameters
source param.sh

# ------------------------------------------------------
# Functions

# Prepare tags as string: concatenate 'before' and 'after' strings with each tags version in array
prepareTags() {
    PREPARED_TAGS=
    local TAG_BEFORE=$1
    local TAG_AFTER=$2
    for TAG_VERSION in "${TAG_VERSIONS[@]}"
    do
        PREPARED_TAGS=${PREPARED_TAGS}${TAG_BEFORE}${TAG_VERSION}${TAG_AFTER}
    done
}

# Launch the docker build command from arguments
launchDockerBuild() {
    local TAGS_OPTS="$1"
    local TARGET_OPTS="$2"
    echo "Build image from ${DOCKERFILE_NAME}:${TARGET_OPTS}${TAGS_OPTS}"
    docker build ${DOCKER_BUILD_ARGS} -f ${DOCKERFILE_NAME}${TARGET_OPTS}${TAGS_OPTS} .
}

# ------------------------------------------------------
# Commands

# Proxy mode to use for build
if [[ "$1" = "noproxy" ]]; then
    echo "No proxy mode"
    DOCKER_BUILD_ARGS="--build-arg http_proxy= --build-arg https_proxy= --build-arg HTTP_PROXY= --build-arg HTTPS_PROXY="
else
    echo "Proxy mode"
    DOCKER_BUILD_ARGS="--build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg APK_ARG_1=--allow-untrusted --build-arg APK_ARG_2=--repository --build-arg APK_ARG_3=http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/"
fi

if [[ ${TAG_SUFFIXES[@]} ]]; then
    # Targets / tags suffixes : build Dockerfile multiple times
    for TARGET in "${!TAG_SUFFIXES[@]}"
    do
        PREPARED_TARGET=" --target ${TARGET}"
        prepareTags " -t ${IMAGE_NAME}:" "${TAG_SEPARATOR}${TAG_SUFFIXES[$TARGET]}"
        launchDockerBuild "${PREPARED_TAGS}" "${PREPARED_TARGET}"
    done
else
    # No target / no tag suffix : build Dockerfile once
    prepareTags " -t ${IMAGE_NAME}:" ""
    launchDockerBuild "${PREPARED_TAGS}"
fi
