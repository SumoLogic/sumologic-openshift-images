## Use original image to copy files from
## ref: https://github.com/thanos-io/thanos/blob/v0.25.2/Dockerfile
FROM quay.io/thanos/thanos:v0.25.2 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

ENV SUMMARY="UBI based thanos" \
    DESCRIPTION="Thanos is a set of components that can be composed into a highly available metric system with unlimited storage capacity, which can be added seamlessly on top of existing Prometheus deployments."

LABEL name="Thanos" \
      vendor="Sumo Logic" \
      version="0.25.2" \
      release="2" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/thanos \
    /bin/thanos
ADD https://raw.githubusercontent.com/thanos-io/thanos/v0.25.2/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT [ "/bin/thanos" ]
