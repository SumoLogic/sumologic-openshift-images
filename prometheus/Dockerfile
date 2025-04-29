ARG UPSTREAM_VERSION
## Use original image to copy files from
## ref: https://github.com/prometheus/prometheus/blob/00f16d1ac3a4c94561e5133b821d8e4d9ef78ec2/Dockerfile
FROM public.ecr.aws/sumologic/prometheus:v${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
ARG ARCH="amd64"
ARG OS="linux"
FROM registry.access.redhat.com/ubi9/ubi:9.5
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based Prometheus image" \
    DESCRIPTION="Prometheus, a Cloud Native Computing Foundation project, is a systems and service monitoring system."

LABEL name="Prometheus" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

ARG ARCH="amd64"
ARG OS="linux"
COPY --from=builder /bin/prometheus                             /bin/prometheus
COPY --from=builder /bin/promtool                               /bin/promtool
COPY --from=builder /etc/prometheus/prometheus.yml              /etc/prometheus/prometheus.yml
COPY --from=builder /usr/share/prometheus/console_libraries/    /usr/share/prometheus/console_libraries/
COPY --from=builder /usr/share/prometheus/consoles/             /usr/share/prometheus/consoles/
COPY --from=builder /LICENSE                                    /licenses/LICENSE
COPY --from=builder /NOTICE                                     /NOTICE
COPY --from=builder /npm_licenses.tar.bz2                       /npm_licenses.tar.bz2

RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/
RUN mkdir -p /prometheus && \
    groupadd nogroup && \
    chown -R nobody:nogroup etc/prometheus /prometheus

USER       nobody
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
    "--storage.tsdb.path=/prometheus", \
    "--web.console.libraries=/usr/share/prometheus/console_libraries", \
    "--web.console.templates=/usr/share/prometheus/consoles" ]
