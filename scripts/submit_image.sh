#!/usr/bin/env bash

set -e

if [ -z ${CONTAINER_PROJECT_ID} ] || [ -z ${CONTAINER_REGISTRY_KEY} ] || [ -z ${SUMOLOGIC_IMAGE} ] || [ -z ${PYAXIS_API_TOKEN} ] 
then
    echo "One of required environment variables is missing"
    echo "required environment variables: CONTAINER_PROJECT_ID, CONTAINER_REGISTRY_KEY, SUMOLOGIC_IMAGE, PYAXIS_API_TOKEN"
    exit 1
fi

echo "${CONTAINER_REGISTRY_KEY}" | docker login -u "redhat-isv-containers+${CONTAINER_PROJECT_ID}-robot" quay.io --password-stdin

# extract tag
TAG="${SUMOLOGIC_IMAGE##*:}" # treat everything after `:` as version

# push image
docker tag ${SUMOLOGIC_IMAGE} "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:${TAG}"
docker push "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:${TAG}"

# prepare temporary auth file
AUTH_KEY=$(echo -n  "redhat-isv-containers+${CONTAINER_PROJECT_ID}-robot:${CONTAINER_REGISTRY_KEY}" | base64 --wrap 0)
AUTH_CONTENT="{\"auths\": {\"quay.io\": {\"auth\": \"${AUTH_KEY}\"}}}"
echo ${AUTH_CONTENT} > temp_auth.json

# submit image
preflight check container "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:${TAG}" \
--submit \
--pyxis-api-token="${PYAXIS_API_TOKEN}" \
--certification-project-id="${CONTAINER_PROJECT_ID}" \
--docker-config=temp_auth.json

# add latest tag
docker tag  ${SUMOLOGIC_IMAGE} "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:latest"
docker push "quay.io/redhat-isv-containers/${CONTAINER_PROJECT_ID}:latest"

rm temp_auth.json
