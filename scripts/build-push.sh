#!/usr/bin/env bash

set -e

# consts
readonly SUMO_REGISTRY="public.ecr.aws/sumologic/"
## Sumo Logic Helm Operator project id
## rel: https://connect.redhat.com/manage/products/6075d88c2b962feb86bea730/overview
readonly OPERATOR_PROJECT_ID=6075d88c2b962feb86bea730

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
    make check PLATFORM="${PLATFORM}" IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${VERSION}"
}

## Perform image submit for certification
function submit(){
    echo "Submitting image for certification, image: ${IMAGE_NAME}"
    ## Fetch container project id based on directory(image) name
    CONTAINER_PROJECT_ID="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" "https://catalog.redhat.com/api/containers/v1/product-listings/id/${OPERATOR_PROJECT_ID}/projects/certification" | jq ".data[] | select(.container.repository_name == \"${NAME}\")._id" --raw-output)"

    if [[ -z ${CONTAINER_PROJECT_ID} ]]; then
        echo "Missing project for ${IMAGE_NAME}"

        ## Create new project
        readonly IMAGE_DESCRIPTION="$(docker inspect "${IMAGE_NAME}" | jq '.[0].Config.Labels.description' --raw-output)"
        readonly IMAGE_SUMMARY="$(docker inspect "${IMAGE_NAME}" | jq '.[0].Config.Labels.summary' --raw-output)"
        readonly APPLICATION_NAME="$(docker inspect "${IMAGE_NAME}" | jq '.[0].Config.Labels.name' --raw-output)"
        export IMAGE_DESCRIPTION
        export IMAGE_SUMMARY
        export APPLICATION_NAME
        DATA="$(envsubst < scripts/new_project.json)"
        RESULT="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" -H 'Content-Type: application/json' -X POST https://catalog.redhat.com/api/containers/v1/projects/certification --data "${DATA}")"
        
        ## Add new project to product
        CONTAINER_PROJECT_ID="$(echo ${RESULT} | jq '._id' --raw-output)"

        if [[ -z ${CONTAINER_PROJECT_ID} ||"${CONTAINER_PROJECT_ID}" == "null" ]]; then
            echo "Error during create project for ${IMAGE_NAME}"
            echo $RESULT 
            exit 1
        fi

        DATA=$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" https://catalog.redhat.com/api/containers/v1/product-listings/id/${OPERATOR_PROJECT_ID} | jq ".cert_projects |= . + [\"${CONTAINER_PROJECT_ID}\"] | {cert_projects}")
        RESULT="$(curl -sH "X-API-KEY: ${PYAXIS_API_TOKEN}" -H 'Content-Type: application/json' -X PATCH https://catalog.redhat.com/api/containers/v1/product-listings/id/${OPERATOR_PROJECT_ID} --data "${DATA}")"
    fi

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
readonly EXTERNAL_IMAGES="(sumologic-otel-collector|kubernetes-setup|kubernetes-tools-kubectl|tailing-sidecar-operator|tailing-sidecar)"
DEV_SUFFIX=""

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
    echo "Image ${IMAGE_NAME} exists, there is no need to push it once again." 2>&1
    exit 0
fi

## Image do not exists or we forcefully want to build and push it

# Build image
if echo "${NAME}" | grep -vE "^${EXTERNAL_IMAGES}\$"; then
    make -C "${NAME}" build IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${UPSTREAM_VERSION}"
else
    echo "${NAME} is build in outside repository. Skipping build"
fi

# Push image
if ! [[ "${ACTION}" =~ ${ACTION_PUSH}|${ACTION_CHECK}|${ACTION_CERTIFY} ]]; then
    exit 0
fi

echo "Pushing image, image: ${IMAGE_NAME}" 2>&1
if echo "${NAME}" | grep -vE "^${EXTERNAL_IMAGES}\$"; then
    make push IMAGE_NAME="${IMAGE_NAME}" UPSTREAM_VERSION="${UPSTREAM_VERSION}"
else
    echo "${NAME} is build in outside repository. Skipping push"
fi

if ! [[ "${ACTION}" =~ ${ACTION_CHECK}|${ACTION_CERTIFY} ]]; then
    exit 0
fi
check

if ! [[ "${ACTION}" =~ ${ACTION_CERTIFY} ]]; then
    exit 0
fi
submit
