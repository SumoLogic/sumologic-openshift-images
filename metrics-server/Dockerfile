ARG UPSTREAM_VERSION
ARG UBI_IMAGE=registry.access.redhat.com/ubi8/ubi:8.6
## Use original image to copy files from
## ref: https://github.com/bitnami/bitnami-docker-metrics-server/blob/${UPSTREAM_VERSION}/0/debian-10/Dockerfile
FROM docker.io/bitnami/metrics-server:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM ${UBI_IMAGE}
ARG UPSTREAM_VERSION
ARG RELEASE

COPY --from=builder /opt/bitnami /opt/bitnami

ENV SUMMARY="UBI based metrics-server" \
    DESCRIPTION="Metrics Server is a cluster-wide aggregator of resource usage data. Metrics Server collects metrics from the Summary API, exposed by Kubelet on each node."

LABEL name="metrics-server" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

ADD https://raw.githubusercontent.com/bitnami/containers/main/LICENSE.md \
    /licenses/LICENSE.md

RUN chmod g+rwX /opt/bitnami
RUN chown -R 1001:root /opt/bitnami/metrics-server && chmod -R g+rwX /opt/bitnami/metrics-server
ENV BITNAMI_APP_NAME="metrics-server" \
    BITNAMI_IMAGE_VERSION="${UPSTREAM_VERSION}" \
    PATH="/opt/bitnami/metrics-server/bin:$PATH"

EXPOSE 8443

WORKDIR /opt/bitnami/metrics-server
USER 1001
ENTRYPOINT [ "metrics-server", "--secure-port=8443", "--cert-dir=/opt/bitnami/metrics-server/certificates" ]
