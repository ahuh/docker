#!/bin/bash

# =======================================================================================
# Docker image parameters
#
# Used in Docker image build scripts
# =======================================================================================

# - URL of the docker registry for push
export DOCKER_REGISTRY=ahuh

# - Name of the image to build
export IMAGE_NAME=docker

# - Array of the tag versions to build for the image
declare -x -a TAG_VERSIONS=(
    23.0.1
    23.0
    23
    latest
)

# - Map of the target (key) and tag suffix (value) for the image
# (remove map declaration for single build, without multi-stage build)
declare -x -A TAG_SUFFIXES=(
    [git-bash]=git-bash
)

# Docker file name to use for build
export DOCKERFILE_NAME=Dockerfile

# Docker tag separator to use between tag version and tag suffix
export TAG_SEPARATOR=-
