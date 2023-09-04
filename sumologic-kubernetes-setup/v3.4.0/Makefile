BUILD_TAG ?= 3.4.0-ubi-2
IMAGE_NAME = kubernetes-setup

build:
	DOCKER_BUILDKIT=1 docker build \
		--load \
		--build-arg BUILD_TAG=$(BUILD_TAG) \
		--tag $(IMAGE_NAME):$(BUILD_TAG) \
		.
