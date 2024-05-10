#!/usr/bin/env bash

IMAGES=$(./scripts/list-images.py --fetch-base --values scripts/values.yaml | grep kube-rbac-proxy)
SUMO_REGISTRY="public.ecr.aws/sumologic/"

for IMAGE in ${IMAGES}; do
    # Treat everything after `:` as version
    VERSION="${IMAGE##*:}"
    # Strip v from version
    UPSTREAM_VERSION="${VERSION##[v]}"
    # get name as other 
    NAME="${IMAGE%%:*}"
    NAME="${NAME##*/}"
    UBI_VERSION="${VERSION}-ubi"

    echo "${SUMO_REGISTRY}${NAME}:${UBI_VERSION}"

    # 
    if docker pull "${SUMO_REGISTRY}${NAME}:${UBI_VERSION}"; then
        # as image exist, we can go to the next one
        continue
    fi

    make -C ${NAME} build UPSTREAM_VERSION="${UPSTREAM_VERSION}"
    make -C ${NAME} push UPSTREAM_VERSION="${UPSTREAM_VERSION}"
done
