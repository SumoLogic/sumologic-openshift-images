ARG UPSTREAM_VERSION

## Use original image to copy files from
## ref: https://github.com/influxdata/influxdata-docker/blob/dd108978ea0e5c0e99ebc745c03973c755702680/telegraf/1.21/Dockerfile
FROM public.ecr.aws/sumologic/telegraf:${UPSTREAM_VERSION} as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi9/ubi:9.4
ARG UPSTREAM_VERSION
ARG RELEASE

ENV SUMMARY="UBI based Telegraf image" \
    DESCRIPTION="Telegraf is an agent for collecting metrics and writing them to InfluxDB or other outputs."

LABEL name="Telegraf" \
    vendor="Sumo Logic" \
    version="${UPSTREAM_VERSION}" \
    release="${RELEASE}" \
    summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    maintainer="opensource-collection-team@sumologic.com"

COPY --from=builder /usr/bin/telegraf \
    /usr/bin/telegraf
COPY --from=builder /etc/telegraf/telegraf.conf \
    /etc/telegraf/telegraf.conf
# copy ca-cerificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs

ADD https://raw.githubusercontent.com/influxdata/telegraf/v${UPSTREAM_VERSION}/LICENSE \
    /licenses/LICENSE

EXPOSE 8125/udp 8092/udp 8094

COPY --from=builder /entrypoint.sh /entrypoint.sh
USER nobody
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
