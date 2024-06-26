OPENSOURCE_ECR_URL = public.ecr.aws/sumologic
BIN="$(abspath $(CURDIR)/bin)/"

list-images-v4:
	./scripts/list-images.py \
    	--fetch-base \
    	--values scripts/values.yaml \
    	--version v4

list-images-v3:
	./scripts/list-images.py \
    	--fetch-base \
    	--values scripts/values.yaml \
    	--version v3

build-all:
	ACTION=build ./scripts/build-push-all.sh

check-all:
	ACTION=check ./scripts/build-push-all.sh

certify-all:
	ACTION=certify ./scripts/build-push-all.sh

verify:
	./scripts/get_images_sha256.sh

install_preflight:
	curl -LO https://github.com/redhat-openshift-ecosystem/openshift-preflight/releases/latest/download/preflight-linux-amd64
	chmod +x preflight-linux-amd64
	mkdir -p ./bin/
	mv preflight-linux-amd64 ./bin/preflight

make build_preflight:
	mkdir -p ./bin
	git clone git@github.com:redhat-openshift-ecosystem/openshift-preflight.git ./bin/preflight-git || true
	# We need to build with RELEASE_TAG env
	cd ./bin/preflight-git && \
	export RELEASE_TAG=$$(git describe --tags $$(git rev-list --tags --max-count=1)) && \
	git checkout "$${RELEASE_TAG}" && \
	make build && \
	mv preflight ../\

_login:
	aws ecr-public get-login-password --region us-east-1 \
	| docker login --username AWS --password-stdin $(ECR_URL)

login:
	$(MAKE) _login \
		ECR_URL="$(OPENSOURCE_ECR_URL)"

check:
	${BIN}preflight check container ${IMAGE_NAME} --platform=${PLATFORM}

push:
	docker push ${IMAGE_NAME}
