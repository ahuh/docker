#!/bin/bash

# =======================================================================================
# Push Docker image
#
# This scripts pushes the Docker image
# =======================================================================================

# ------------------------------------------------------
# Import parameters
source param.sh

# ------------------------------------------------------
# Functions

# Launch the docker tag command from arguments
launchDockerTag() {
    local TAG_SUFFIX="$1"
    for TAG_VERSION in "${TAG_VERSIONS[@]}"
    do
        echo "Tag image ${IMAGE_NAME}:${TAG_VERSION}${TAG_SUFFIX} to custom registry ${DOCKER_REGISTRY}/${IMAGE_NAME}"
        docker tag ${IMAGE_NAME}:${TAG_VERSION}${TAG_SUFFIX} ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG_VERSION}${TAG_SUFFIX}
    done
}

# Launch the docker push command
launchDockerPush() {
    echo "Push images with all tags to custom registry: ${DOCKER_REGISTRY}/${IMAGE_NAME}"
    docker push --all-tags ${DOCKER_REGISTRY}/${IMAGE_NAME}
}

# ------------------------------------------------------
# Commands

if [[ ${TAG_SUFFIXES[@]} ]]; then
    # Targets / tags suffixes
    for TARGET in "${!TAG_SUFFIXES[@]}"
    do
        launchDockerTag "${TAG_SEPARATOR}${TAG_SUFFIXES[$TARGET]}"
    done
else
    # No target / no tag suffix
    launchDockerTag ""
fi

launchDockerPush
