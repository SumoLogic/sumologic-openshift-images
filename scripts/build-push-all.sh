#!/usr/bin/env bash

set -e

HELM_CHART_VERSION=v4
SUMO_REGISTRY="public.ecr.aws/sumologic/"
PUSH=""
CHECK="${CHECK:-true}"

IMAGES=$(./scripts/list-images.py \
    --fetch-base \
    --values scripts/values.yaml \
    --version "${HELM_CHART_VERSION}" \
        | grep -E 'kube-rbac-proxy|metrics-server|prometheus-config-reloader|prometheus-operator|prometheus|opentelemetry-operator|node-exporter|telegraf|telegraf-operator|thanos|autoinstrumentation|fluent-bit|busybox')

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
        # as image exist, we can go to the next one
        make -C ${NAME} check IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
        continue
    fi

    make -C ${NAME} build IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"

    if [[ -n "${PUSH}" ]]; then
        make -C ${NAME} push IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
    fi

    if [[ "${CHECK}" == "true" ]]; then
        make -C ${NAME} check IMAGE_NAME=${IMAGE_NAME} UPSTREAM_VERSION="${UPSTREAM_VERSION}"
    fi
done
