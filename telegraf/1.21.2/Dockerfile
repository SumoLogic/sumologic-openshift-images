## Use original image to copy files from
## ref: https://github.com/influxdata/influxdata-docker/blob/dd108978ea0e5c0e99ebc745c03973c755702680/telegraf/1.21/Dockerfile
FROM telegraf:1.21.2 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6

ENV SUMMARY="UBI based telegraf" \
    DESCRIPTION="Telegraf is an agent for collecting metrics and writing them to InfluxDB or other outputs."

LABEL name="telegraf" \
      vendor="Sumo Logic" \
      version="1.21.2" \
      release="2" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      maintainer="collection@sumologic.com"

COPY --from=builder /usr/bin/telegraf \
    /usr/bin/telegraf
COPY --from=builder /etc/telegraf/telegraf.conf \
    /etc/telegraf/telegraf.conf
# copy ca-cerificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs

ADD https://raw.githubusercontent.com/influxdata/influxdata-docker/dd108978ea0e5c0e99ebc745c03973c755702680/telegraf/LICENSE \
    /licenses/LICENSE

EXPOSE 8125/udp 8092/udp 8094

COPY --from=builder /entrypoint.sh /entrypoint.sh
USER nobody
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
