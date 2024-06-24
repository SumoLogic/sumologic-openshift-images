#!/usr/bin/env bash

set -e

# consts
## Sumo Logic Helm Operator project id
## rel: https://connect.redhat.com/manage/products/6075d88c2b962feb86bea730/overview
readonly OPERATOR_PROJECT_ID=6075d88c2b962feb86bea730

function cleanup() {
    if [[ -n ${CONTAINER_PROJECT_ID} && -n ${SUMOLOGIC_IMAGE} ]]; then
        readonly APPLICATION_NAME="$(docker inspect ${SUMOLOGIC_IMAGE} | jq '.[0].Config.Labels.name' --raw-output)"
        echo "https://connect.redhat.com/component/${OPERATOR_PROJECT_ID}/${CONTAINER_PROJECT_ID}/certification"
        echo "Project ID: ${CONTAINER_PROJECT_ID}"
        echo "Name of Application: ${APPLICATION_NAME}"
    fi
}

trap cleanup EXIT

if [ -z ${CONTAINER_PROJECT_ID} ] || [ -z ${SUMOLOGIC_IMAGE} ] || [ -z ${PYAXIS_API_TOKEN} ]
then
    echo "One of required environment variables is missing"
    echo "required environment variables: CONTAINER_PROJECT_ID, SUMOLOGIC_IMAGE, PYAXIS_API_TOKEN"
    exit 1
fi

AUTH_CONTENT="${AUTH_CONTENT}"
readonly PLATFORM="${PLATFORM:-amd64}"

if [[ -z "${CONTAINER_REGISTRY_KEY}" || "${CONTAINER_REGISTRY_KEY}"=="null" ]]; then
    echo "Invalid CONTAINER_REGISTRY_KEY. Assuming that the original registry should be used and just submitting results"

    # submit image
    ${BIN}preflight check container "${SUMOLOGIC_IMAGE}" \
    --submit \
    --pyxis-api-token="${PYAXIS_API_TOKEN}" \
    --certification-project-id="${CONTAINER_PROJECT_ID}" \
    --platform="${PLATFORM}"
    exit 0
fi

echo "${CONTAINER_REGISTRY_KEY}" | docker login -u "redhat-isv-containers+${CONTAINER_PROJECT_ID}-robot" quay.io --password-stdin

# extract tag
TAG="${SUMOLOGIC_IMAGE##*:}" # treat everything after `:` as version

# push image
docker tag ${SUMOLOGIC_IMAGE} "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:${TAG}"
docker push "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:${TAG}"

# prepare temporary auth file
if [[ -z "${AUTH_CONTENT}" ]]; then
    AUTH_KEY=$(echo -n  "redhat-isv-containers+${CONTAINER_PROJECT_ID}-robot:${CONTAINER_REGISTRY_KEY}" | base64 --wrap 0)
    AUTH_CONTENT="{\"auths\": {\"quay.io\": {\"auth\": \"${AUTH_KEY}\"}}}"
fi
echo ${AUTH_CONTENT} > temp_auth.json

# submit image
${BIN}preflight check container "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:${TAG}" \
--submit \
--pyxis-api-token="${PYAXIS_API_TOKEN}" \
--certification-project-id="${CONTAINER_PROJECT_ID}" \
--docker-config=temp_auth.json \
--platform="${PLATFORM}"

# add latest tag
docker tag  ${SUMOLOGIC_IMAGE} "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:latest"
docker push "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:latest"

rm temp_auth.json
