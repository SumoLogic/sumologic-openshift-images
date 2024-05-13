#!/usr/bin/make -f

UPSTREAM_VERSION = ""
VERSION_PREFIX = ""
VERSION = "${VERSION_PREFIX}${UPSTREAM_VERSION}"
IMAGE_NAME = "metrics-server"

build:
	RELEASE=$(shell docker inspect public.ecr.aws/sumologic/${IMAGE_NAME}:${VERSION}-ubi | jq '.[0].Config.Labels.release | tonumber + 1' --raw-output -e || echo '1') ;\
	docker build . -t public.ecr.aws/sumologic/${IMAGE_NAME}:${VERSION}-ubi --build-arg UPSTREAM_VERSION=${UPSTREAM_VERSION} --build-arg RELEASE=$${RELEASE}

push:
	docker push public.ecr.aws/sumologic/${IMAGE_NAME}:${VERSION}-ubi
