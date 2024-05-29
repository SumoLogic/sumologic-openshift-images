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
