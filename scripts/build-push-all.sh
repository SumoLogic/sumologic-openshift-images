#!/usr/bin/env bash

set -e

HELM_CHART_VERSION=v4
SUMO_REGISTRY="public.ecr.aws/sumologic/"
CHECK="${CHECK:-true}"
CERTIFY="${CERTIFY:-false}"
PUSH="${PUSH:-false}"

## Sumo Logic Helm Operator project id
## rel: https://connect.redhat.com/manage/products/6075d88c2b962feb86bea730/overview
readonly OPERATOR_PROJECT_ID=6075d88c2b962feb86bea730

if [[ -z "${PYAXIS_API_TOKEN}" && "${CHECK}" == "true" ]]; then
    echo "PYAXIS_API_TOKEN is required to perform check"
    exit -1
fi

## Perform image check
function check(){
    echo "Checking image, image: ${IMAGE_NAME}"
    make -C ${NAME} check IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
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


IMAGES=$(./scripts/list-images.py \
    --fetch-base \
    --values scripts/values.yaml \
    --version "${HELM_CHART_VERSION}" \
    | grep -vE '\/(sumologic-otel-collector|kubernetes-setup|kubernetes-tools-kubectl|tailing-sidecar-operator|tailing-sidecar):')

for IMAGE in ${IMAGES}; do
    # Treat everything after `:` as version
    VERSION="${IMAGE##*:}"
    # Strip v from version
    UPSTREAM_VERSION="${VERSION##[v]}"
    # get name as string between `/` and `:`
    NAME="${IMAGE%%:*}"
    NAME="${NAME##*/}"
    UBI_VERSION="${VERSION}-ubi"

    if [[ "${CERTIFY}" == "false" ]]; then
        DEV_SUFFIX="-dev"
    fi

    IMAGE_NAME="${SUMO_REGISTRY}${NAME}:${UBI_VERSION}${DEV_SUFFIX}"
    echo "Image: ${IMAGE_NAME}"

    if docker pull ${IMAGE_NAME}; then
        if [[ "${CHECK}" == "true" ]]; then
            check
        fi

        if [[ ${DEV_SUFFIX} != "-dev" ]]; then
            # as non-dev image exists, we can go to the next one
            # we may want push dev images once again, e.g. with fixes
            echo "Image ${IMAGE_NAME} exists, there is no need to push it once again, continue with next image."
            continue
        fi
    fi

    make -C ${NAME} build IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"

    if [[ "${PUSH}" == "true" ]]; then
        echo "Pushing image, image: ${IMAGE_NAME}"
        make -C ${NAME} push IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
    fi

    if [[ "${CHECK}" == "true" ]]; then
        check
    fi

    if [[ "${CERTIFY}" == "true" ]]; then
        submit
    fi
done
