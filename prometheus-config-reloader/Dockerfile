ARG UPSTREAM_VERSION
ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:8.6
## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/v${UPSTREAM_VERSION}/cmd/prometheus-config-reloader/Dockerfile
FROM public.ecr.aws/sumologic/prometheus-config-reloader:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM ${UBI_IMAGE}
ARG UPSTREAM_VERSION
ARG RELEASE

ENV  SUMMARY="UBI based prometheus-config-reloader" \
    DESCRIPTION="Prometheus configuration reloader"

LABEL name="Prometheus-config-reloader" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

COPY --from=builder \
    /bin/prometheus-config-reloader \
    /bin/prometheus-config-reloader
ADD https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT ["/bin/prometheus-config-reloader"]
