ARG UPSTREAM_VERSION

## Use original image to copy files from
## ref: https://github.com/kubernetes/kube-state-metrics/blob/v${UPSTREAM_VERSION}/Dockerfile
FROM public.ecr.aws/sumologic/kube-state-metrics:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.4
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based kube-state-metrics" \
    DESCRIPTION="kube-state-metrics is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects."

LABEL name="Kube-state-metrics" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

COPY --from=builder \
    /kube-state-metrics \
    /
ADD https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v1.9.8/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
