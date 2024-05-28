#!/usr/bin/env bash

set -e

HELM_CHART_VERSION=v4
SUMO_REGISTRY="public.ecr.aws/sumologic/"
PUSH=""
CHECK="${CHECK:-true}"
## Sumo Logic Helm Operator project id
## rel: https://connect.redhat.com/manage/products/6075d88c2b962feb86bea730/overview
readonly OPERATOR_PROJECT_ID=6075d88c2b962feb86bea730

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
    IMAGE_NAME="${SUMO_REGISTRY}${NAME}:${UBI_VERSION}"

    echo ${IMAGE_NAME}
    if docker pull ${IMAGE_NAME}; then
        if [[ "${CHECK}" == "true" ]]; then
            make -C ${NAME} check IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
        fi
        # as image exist, we can go to the next one
        continue
    fi

    make -C ${NAME} build IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"

    if [[ -n "${PUSH}" ]]; then
        make -C ${NAME} push IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
    fi

    if [[ "${CHECK}" == "true" ]]; then
        make -C ${NAME} check IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
    fi

    # prepare image to submit
    CONTAINER_PROJECT_ID="$(curl -sH "X-API-KEY: ${RED_HAT_API_KEY}" "https://catalog.redhat.com/api/containers/v1/product-listings/id/${OPERATOR_PROJECT_ID}/projects/certification" | jq ".data[] | select(.name == \"${NAME}\")._id" --raw-output)"
    CONTAINER_REGISTRY_KEY="$(curl -sH "X-API-KEY: ${RED_HAT_API_KEY}" "https://catalog.redhat.com/api/containers/v1/projects/certification/id/${CONTAINER_PROJECT_ID}/secrets" | jq ".registry_credentials.password" --raw-output)"
    SUMOLOGIC_IMAGE=${IMAGE_NAME}
done
