#!/usr/bin/env bash

set -e

# consts
readonly SUMO_REGISTRY="public.ecr.aws/sumologic/"

function usage() {
    echo "usage: NAME=image name VERSION= PYAXIS_API_TOKEN= ./scripts/build-push.sh

PYAXIS_API_TOKEN    token for Red Hat API
NAME                image to build, for example 'opentelemetry-operator'
VERSION             version to build from (without prefix), for example '0.95.0', even if the build is from 'v0.95.0'
PUSH                set to 'true' to push image. Default is 'false'
CHECK               set to 'true' to perform preflight check on the image. Default is 'false', requires 'PUSH=true'
CERTIFY             set to 'true' to certify image. If 'false', it will use '-dev' suffix for image tag. Default is 'false', requires 'CHECK=true'
FORCE               set to 'true' to perform action if image already exist in repository. Default is 'false'"
}

## Perform image check
function check(){
    echo "Checking image, image: ${IMAGE_NAME}"
    make -C "${NAME}" check IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${VERSION}"
}

## Perform image submit for certification
function submit(){
    echo "Submitting image for cerification, image: ${IMAGE_NAME}"
    ## Fetch container project id based on directory(image) name
    CONTAINER_PROJECT_ID="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" "https://catalog.redhat.com/api/containers/v1/product-listings/id/${OPERATOR_PROJECT_ID}/projects/certification" | jq ".data[] | select(.name == \"${NAME}\")._id" --raw-output)"
    ## Fetch key for image registry
    CONTAINER_REGISTRY_KEY="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" "https://catalog.redhat.com/api/containers/v1/projects/certification/id/${CONTAINER_PROJECT_ID}/secrets" | jq ".registry_credentials.password" --raw-output)"

    CONTAINER_PROJECT_ID=${CONTAINER_PROJECT_ID} \
    CONTAINER_REGISTRY_KEY=${CONTAINER_REGISTRY_KEY} \
    SUMOLOGIC_IMAGE=${IMAGE_NAME} \
    ./scripts/submit_image.sh
}

# NAME is a directory (image) name, for example `opentelemetry-operator`
readonly NAME="${NAME}"
readonly VERSION="${VERSION}"
# Strip v from version
readonly UPSTREAM_VERSION="${VERSION##[v]}"
readonly CHECK="${CHECK:-true}"
readonly PUSH="${PUSH:-false}"
readonly CERTIFY="${CERTIFY:-false}"
readonly FORCE="${FORCE:-false}"
readonly PYAXIS_API_TOKEN="${PYAXIS_API_TOKEN}"
DEV_SUFFIX=""

if [[ -z "${NAME}" ]]; then
    echo 'Missing NAME variable' 2>&1
    usage
    exit 1
fi

if [[ -z "${VERSION}" ]]; then
    echo 'Missing VERSION variable' 2>&1
    usage
    exit 1
fi

if [[ -z "${PYAXIS_API_TOKEN}" ]]; then
    echo 'Missing PYAXIS_API_TOKEN variable' 2>&1
    usage
    exit 1
fi

if [[ "${CERTIFY}" == "false" ]]; then
    DEV_SUFFIX="-dev"
fi
readonly DEV_SUFFIX

readonly UBI_VERSION="${VERSION}-ubi"
readonly IMAGE_NAME="${SUMO_REGISTRY}${NAME}:${UBI_VERSION}${DEV_SUFFIX}"

if docker pull "${IMAGE_NAME}" && [[ "${FORCE}" == "false" ]]; then
    echo "Image ${IMAGE_NAME} exists, there is no need to push it once again, continue with next image." 2>&1
    exit 0
fi

## Image do not exists or we forcefully want to build and push it

# Build image
make -C "${NAME}" build IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${UPSTREAM_VERSION}"

# Push image
if [[ "${PUSH}" != "true" ]]; then
    exit 0
fi

echo "Pushing image, image: ${IMAGE_NAME}" 2>&1
make -C "${NAME}" push IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${UPSTREAM_VERSION}"

if [[ "${CHECK}" == "false" ]]; then
    exit 0
fi
check

if [[ "${CERTIFY}" == "false" ]]; then
    exit 0
fi

submit