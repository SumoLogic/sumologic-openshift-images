ARG UPSTREAM_VERSION
## Use original image to copy files from
## ref: https://github.com/kubernetes-sigs/metrics-server/blob/v${UPSTREAM_VERSION}/Dockerfile
FROM registry.k8s.io/metrics-server/metrics-server:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.8
ARG UPSTREAM_VERSION
ARG RELEASE

COPY --from=builder /metrics-server /

ENV SUMMARY="UBI based Metrics Server image" \
    DESCRIPTION="Metrics Server is a cluster-wide aggregator of resource usage data. Metrics Server collects metrics from the Summary API, exposed by Kubelet on each node."

LABEL name="Metrics Server" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

ADD https://raw.githubusercontent.com/kubernetes-sigs/metrics-server/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

EXPOSE 8443

USER nobody

ENTRYPOINT [ "/metrics-server", "--secure-port=8443" ]
