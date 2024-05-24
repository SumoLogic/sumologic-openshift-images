#!/usr/bin/env bash

set -e

HELM_CHART_VERSION=v3
SUMO_REGISTRY="public.ecr.aws/sumologic/"
PUSH=""

IMAGES=$(./scripts/list-images.py \
    --fetch-base \
    --values scripts/values.yaml \
    --version "${HELM_CHART_VERSION}" \
        | grep -E 'kube-rbac-proxy|metrics-server|prometheus-config-reloader|prometheus-operator|prometheus|opentelemetry-operator|node-exporter|telegraf|telegraf-operator|thanos')

for IMAGE in ${IMAGES}; do
    # Treat everything after `:` as version
    VERSION="${IMAGE##*:}"
    # Strip v from version
    UPSTREAM_VERSION="${VERSION##[v]}"
    # get name as string between `/` and `:`
    NAME="${IMAGE%%:*}"
    NAME="${NAME##*/}"
    UBI_VERSION="${VERSION}-ubi"

    echo "${SUMO_REGISTRY}${NAME}:${UBI_VERSION}"

    if docker pull "${SUMO_REGISTRY}${NAME}:${UBI_VERSION}"; then
        # as image exist, we can go to the next one
        continue
    fi

    make -C ${NAME} build UPSTREAM_VERSION="${UPSTREAM_VERSION}"

    if [[ -n "${PUSH}" ]]; then
        make -C ${NAME} push UPSTREAM_VERSION="${UPSTREAM_VERSION}"
    fi
done
