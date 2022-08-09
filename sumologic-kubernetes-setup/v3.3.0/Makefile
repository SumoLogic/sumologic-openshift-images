BUILD_TAG ?= v3.3.0-ubi
IMAGE_NAME = kubernetes-setup

build:
	DOCKER_BUILDKIT=1 docker build \
		--load \
		--build-arg BUILD_TAG=$(BUILD_TAG) \
		--tag $(IMAGE_NAME):$(BUILD_TAG) \
		.
