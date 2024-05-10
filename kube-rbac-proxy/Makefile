#!/usr/bin/make -f

UPSTREAM_VERSION = ""

build:
	RELEASE=$(shell docker inspect public.ecr.aws/sumologic/kube-rbac-proxy:v${UPSTREAM_VERSION}-ubi | jq '.[0].Config.Labels.release | tonumber + 1' --raw-output -e || echo '1') ;\
	docker build . -t public.ecr.aws/sumologic/kube-rbac-proxy:v${UPSTREAM_VERSION}-ubi --build-arg UPSTREAM_VERSION=${UPSTREAM_VERSION} --build-arg RELEASE=$${RELEASE}

push:
	docker push public.ecr.aws/sumologic/kube-rbac-proxy:v${UPSTREAM_VERSION}-ubi
