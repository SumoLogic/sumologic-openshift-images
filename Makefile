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
	PUSH=true CERTIFY=false CHECK=true ./scripts/build-push-all.sh

certify:
	PUSH=true CERTIFY=true CHECK=false ./scripts/build-push-all.sh
