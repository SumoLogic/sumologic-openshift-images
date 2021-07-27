## Use original image to copy files from
## ref: https://github.com/thanos-io/thanos/blob/698c7a922cd5dcaa53e305db5c2adb4e79d328ba/Dockerfile
FROM quay.io/thanos/thanos:v0.10.0 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Thanos" \
      vendor="SumoLogic" \
      version="0.10.0" \
      release="1" \
      summary="UBI based thanos" \
      description="Thanos is a set of components that can be composed into a highly available metric system with unlimited storage capacity, which can be added seamlessly on top of existing Prometheus deployments." \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/thanos \
    /bin/thanos
ADD https://raw.githubusercontent.com/thanos-io/thanos/698c7a922cd5dcaa53e305db5c2adb4e79d328ba/LICENSE \
    /licenses/LICENSE

ENTRYPOINT [ "/bin/thanos" ]
