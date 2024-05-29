#!/usr/bin/env bash

set -e

# consts
readonly SUMO_REGISTRY="public.ecr.aws/sumologic/"

function usage() {
    echo "usage: NAME=image name VERSION= PYAXIS_API_TOKEN= ./scripts/build-push.sh

PYAXIS_API_TOKEN    token for Red Hat API
NAME                image to build, for example 'opentelemetry-operator'
VERSION             version to build from (without prefix), for example 'v0.95.0'
ACTION              action to perform. Default is 'build', can be 'build', 'push', 'check' or 'certify'
                    - 'build' - build image with '-dev' suffix
                    - 'push' - build and push image with '-dev' suffix 
                    - 'check' - build and push image with '-dev' suffix and then perform preflight check
                    - 'certify' - build and push image without any suffix, perform preflight check and perform certification process
FORCE               set to 'true' to perform action if image already exist in repository. Default is 'false'
PLATFORM            platform to test. Default is 'amd64'"
}

## Perform image check
function check(){
    echo "Checking image, image: ${IMAGE_NAME}"
    make -C "${NAME}" check PLATFORM="${PLATFORM}" IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${VERSION}"
}

## Perform image submit for certification
function submit(){
    echo "Submitting image for cerification, image: ${IMAGE_NAME}"
    ## Fetch container project id based on directory(image) name
    CONTAINER_PROJECT_ID="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" "https://catalog.redhat.com/api/containers/v1/product-listings/id/${OPERATOR_PROJECT_ID}/projects/certification" | jq ".data[] | select(.name == \"${NAME}\")._id" --raw-output)"
    ## Fetch key for image registry
    CONTAINER_REGISTRY_KEY="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" "https://catalog.redhat.com/api/containers/v1/projects/certification/id/${CONTAINER_PROJECT_ID}/secrets" | jq ".registry_credentials.password" --raw-output)"
    DOCKER_CONFIG_JSON="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" "https://catalog.redhat.com/api/containers/v1/projects/certification/id/${CONTAINER_PROJECT_ID}/secrets" | jq ".docker_config_json" --raw-output)"

    CONTAINER_PROJECT_ID=${CONTAINER_PROJECT_ID} \
    CONTAINER_REGISTRY_KEY=${CONTAINER_REGISTRY_KEY} \
    AUTH_CONTENT=${DOCKER_CONFIG_JSON} \
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
readonly PLATFORM="${PLATFORM:-amd64}"
readonly ACTION_BUILD="build"
readonly ACTION_PUSH="push"
readonly ACTION_CHECK="check"
readonly ACTION_CERTIFY="certify"
readonly ACTION="${ACTION:-${ACTION_BUILD}}"
DEV_SUFFIX=""

## Sumo Logic Helm Operator project id
## rel: https://connect.redhat.com/manage/products/6075d88c2b962feb86bea730/overview
readonly OPERATOR_PROJECT_ID=6075d88c2b962feb86bea730

if ! [[ "$ACTION" =~ ${ACTION_BUILD}|${ACTION_PUSH}|${ACTION_CHECK}|${ACTION_CERTIFY} ]]; then
    echo "ACTION should be '${ACTION_BUILD}', '${ACTION_PUSH}', '${ACTION_CHECK}' or ${ACTION_CERTIFY}"
    exit 1
fi

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

if [[ -z "${PYAXIS_API_TOKEN}" && "${ACTION}" =~ ${ACTION_CHECK}|${ACTION_CERTIFY} ]]; then
    echo 'Missing PYAXIS_API_TOKEN variable' 2>&1
    usage
    exit 1
fi

if [[ "${ACTION}" != "${ACTION_CERTIFY}" ]]; then
    DEV_SUFFIX="-dev"
fi
readonly DEV_SUFFIX

readonly UBI_VERSION="${VERSION}-ubi"
readonly IMAGE_NAME="${SUMO_REGISTRY}${NAME}:${UBI_VERSION}${DEV_SUFFIX}"

echo "Image: ${IMAGE_NAME}"

if docker pull "${IMAGE_NAME}" && [[ "${FORCE}" == "false" ]]; then
    echo "Image ${IMAGE_NAME} exists, there is no need to push it once again, continue with next image." 2>&1
    exit 0
fi

## Image do not exists or we forcefully want to build and push it

# Build image
make -C "${NAME}" build IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${UPSTREAM_VERSION}"

# Push image
if ! [[ "${ACTION}" =~ ${ACTION_PUSH}|${ACTION_CHECK}|${ACTION_CERTIFY} ]]; then
    exit 0
fi

echo "Pushing image, image: ${IMAGE_NAME}" 2>&1
make -C "${NAME}" push IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${UPSTREAM_VERSION}"

if ! [[ "${ACTION}" =~ ${ACTION_CHECK}|${ACTION_CERTIFY} ]]; then
    exit 0
fi
check

if ! [[ "${ACTION}" =~ ${ACTION_CERTIFY} ]]; then
    exit 0
fi
submit
