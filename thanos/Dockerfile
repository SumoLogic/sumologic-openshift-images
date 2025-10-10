ARG UPSTREAM_VERSION

## Use original image to copy files from
## ref: https://github.com/thanos-io/thanos/blob/v0.25.2/Dockerfile
FROM public.ecr.aws/sumologic/thanos:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.6
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based Thanos image" \
    DESCRIPTION="Thanos is a set of components that can be composed into a highly available metric system with unlimited storage capacity, which can be added seamlessly on top of existing Prometheus deployments."

LABEL name="Thanos" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

COPY --from=builder \
    /bin/thanos \
    /bin/thanos
ADD https://raw.githubusercontent.com/thanos-io/thanos/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT [ "/bin/thanos" ]
