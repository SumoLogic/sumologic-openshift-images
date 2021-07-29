build:
	docker build . -t sumo-ubi-minimal:8.4

push:
	docker tag sumo-ubi-minimal:8.4 public.ecr.aws/sumologic/sumo-ubi-minimal:8.4
	docker push public.ecr.aws/sumologic/sumo-ubi-minimal:8.4
