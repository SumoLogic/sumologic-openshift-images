ARG UPSTREAM_VERSION
## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/v${UPSTREAM_VERSION}/cmd/prometheus-config-reloader/Dockerfile
FROM public.ecr.aws/sumologic/prometheus-config-reloader:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.6
ARG UPSTREAM_VERSION
ARG RELEASE

ENV  SUMMARY="UBI based Prometheus Configuration Reloader image" \
    DESCRIPTION="Prometheus Configuration Reloader automatically reloads Prometheus Configuration"

LABEL name="Prometheus Configuration Reloader" \
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
