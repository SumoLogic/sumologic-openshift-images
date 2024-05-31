OPENSOURCE_ECR_URL = public.ecr.aws/sumologic

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

check:
	ACTION=check ./scripts/build-push-all.sh

certify:
	ACTION=certify ./scripts/build-push-all.sh

verify:
	./scripts/get_images_sha256.sh

install_preflight:
	curl -LO https://github.com/redhat-openshift-ecosystem/openshift-preflight/releases/latest/download/preflight-linux-amd64
	chmod +x preflight-linux-amd64
	mkdir -p ./bin/
	mv preflight-linux-amd64 ./bin/preflight

_login:
	aws ecr-public get-login-password --region us-east-1 \
	| docker login --username AWS --password-stdin $(ECR_URL)

login:
	$(MAKE) _login \
		ECR_URL="$(OPENSOURCE_ECR_URL)"
