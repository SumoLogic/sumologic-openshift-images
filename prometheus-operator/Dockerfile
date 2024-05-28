ARG UPSTREAM_VERSION

## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/v${UPSTREAM_VERSION}/Dockerfile
FROM public.ecr.aws/sumologic/prometheus-operator:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.4
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based prometheus-operator" \
    DESCRIPTION="The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components."

LABEL name="Prometheus-operator" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

COPY --from=builder \
    /bin/operator \
    /bin/operator
ADD https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

# On busybox 'nobody' has uid `65534'
USER 65534

ENTRYPOINT ["/bin/operator"]
