#!/usr/bin/env bash

set -e

readonly HELM_CHART_VERSION=v4
readonly ACTION_BUILD="build"
readonly ACTION_PUSH="push"
readonly ACTION_CHECK="check"
readonly ACTION_CERTIFY="certify"
readonly ACTION="${ACTION:-${ACTION_BUILD}}"

if ! [[ "$ACTION" =~ ${ACTION_BUILD}|${ACTION_PUSH}|${ACTION_CHECK}|${ACTION_CERTIFY} ]]; then
    echo "ACTION should be '${ACTION_BUILD}', '${ACTION_PUSH}', '${ACTION_CHECK}' or ${ACTION_CERTIFY}"
    exit 1
fi

if [[ -z "${PYAXIS_API_TOKEN}" && ( "${ACTION}" =~ ${ACTION_CHECK}|${ACTION_CERTIFY} ) ]]; then
    echo "PYAXIS_API_TOKEN is required to perform check" 2>&1
    exit 1
fi

IMAGES=$(./scripts/list-images.py \
    --fetch-base \
    --values scripts/values.yaml \
    --version "${HELM_CHART_VERSION}" \
    | grep -vE '\/(sumologic-otel-collector|kubernetes-setup|kubernetes-tools-kubectl|tailing-sidecar-operator|tailing-sidecar):')

for IMAGE in ${IMAGES}; do
    # Treat everything after `:` as version
    VERSION="${IMAGE##*:}"
    # get name as string between `/` and `:`
    NAME="${IMAGE%%:*}"
    NAME="${NAME##*/}"

   PYAXIS_API_TOKEN="${PYAXIS_API_TOKEN=}" \
   NAME="${NAME}" \
   ACTION="${ACTION}" \
   VERSION="${VERSION}" \
   ./scripts/build-push.sh
done
