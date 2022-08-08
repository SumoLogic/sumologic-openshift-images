## Use original image to copy files from
## ref: https://github.com/bitnami/bitnami-docker-metrics-server/blob/0.6.1-debian-10-r67/0/debian-10/Dockerfile
FROM docker.io/bitnami/metrics-server:0.6.1-debian-10-r67 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

COPY --from=builder /opt/bitnami /opt/bitnami

LABEL name="metrics-server" \
      vendor="Sumo Logic" \
      version="0.6.1-debian-10-r67" \
      release="2" \
      summary="UBI based metrics-server" \
      description="Metrics Server is a cluster-wide aggregator of resource usage data. Metrics Server collects metrics from the Summary API, exposed by Kubelet on each node." \
      maintainer="collection@sumologic.com"

ADD https://raw.githubusercontent.com/bitnami/bitnami-docker-metrics-server/0.6.1-debian-10-r67/LICENSE.md \
    /licenses/LICENSE.md

RUN chmod g+rwX /opt/bitnami
RUN chown -R 1001:root /opt/bitnami/metrics-server && chmod -R g+rwX /opt/bitnami/metrics-server
ENV BITNAMI_APP_NAME="metrics-server" \
    BITNAMI_IMAGE_VERSION="0.6.1-debian-10-r67" \
    PATH="/opt/bitnami/metrics-server/bin:$PATH"

EXPOSE 8443

WORKDIR /opt/bitnami/metrics-server
USER 1001
ENTRYPOINT [ "metrics-server", "--secure-port=8443", "--cert-dir=/opt/bitnami/metrics-server/certificates" ]
