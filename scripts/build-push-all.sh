#!/usr/bin/env bash

set -e

HELM_CHART_VERSION=v4
SUMO_REGISTRY="public.ecr.aws/sumologic/"
CHECK="${CHECK:-true}"
CERTIFY="${CERTIFY:-false}"
PUSH="${PUSH:-false}"


if [[ -z "${PYAXIS_API_TOKEN}" && "${CHECK}" == "true" ]]; then
    echo "PYAXIS_API_TOKEN is required to perform check"
    exit -1
fi

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

   PYAXIS_API_TOKEN="${PYAXIS_API_TOKEN=}" \
   NAME="${NAME}" \
   VERSION="${VERSION}" \
   CHECK="${CHECK}" \
   PUSH="${PUSH}" \
   CERTIFY="${CERTIFY}" \
   ./scripts/build-push.sh
done
