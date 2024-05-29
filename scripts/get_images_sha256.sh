#!/usr/bin/env bash

HELM_CHART_VERSION=v4
UBI_SUFFIX="-ubi"
REDHAT_REGISTRY="registry.connect.redhat.com/sumologic/"

IMAGES=$(./scripts/list-images.py \
    --fetch-base \
    --values scripts/values.yaml \
    --version "${HELM_CHART_VERSION}" \
    | grep -vE '\/(sumologic-otel-collector|kubernetes-setup|kubernetes-tools-kubectl|tailing-sidecar-operator|tailing-sidecar):' )

for IMAGE in ${IMAGES}; do
  # Treat everything after `:` as version
  VERSION="${IMAGE##*:}"
  # get name as string between `/` and `:`
  NAME="${IMAGE%%:*}"
  NAME="${NAME##*/}"
  UBI_VERSION="${VERSION}-ubi"
  REDHAT_IMAGE=${REDHAT_REGISTRY}${NAME}:${UBI_VERSION}

  DIGEST=$(docker pull ${REDHAT_IMAGE} 2> /dev/null | grep "Digest")

  if [[ ${DIGEST} == "" ]]; then
    REDHAT_IMAGE_WITH_SHA256="MISSING"
  else
    # Treat everything after `:` as digest
    DIGEST="${DIGEST##*:}"
    REDHAT_IMAGE_WITH_SHA256=${REDHAT_REGISTRY}${NAME}:@sha256:${DIGEST}
  fi

  echo ${REDHAT_IMAGE}
  echo ${REDHAT_IMAGE_WITH_SHA256}
done
