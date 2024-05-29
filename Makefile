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
	CHECK=false ./scripts/build-push-all.sh

check:
	PUSH=true CHECK=true CERTIFY=false ./scripts/build-push-all.sh

certify:
	PUSH=true CHECK=true CERTIFY=true ./scripts/build-push-all.sh

_login:
	aws ecr-public get-login-password --region us-east-1 \
	| docker login --username AWS --password-stdin $(ECR_URL)

login:
	$(MAKE) _login \
		ECR_URL="$(OPENSOURCE_ECR_URL)"
