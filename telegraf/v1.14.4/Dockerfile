## Use original image to copy files from
## ref: https://github.com/influxdata/influxdata-docker/blob/1d3c13915c892a46bca5da3e3369b8620be6df80/telegraf/1.14/Dockerfile
FROM telegraf:1.14.4 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

LABEL name="telegraf" \
      vendor="Sumo Logic" \
      version="1.14.4" \
      release="1" \
      summary="UBI based telegraf" \
      description="Telegraf is an agent for collecting metrics and writing them to InfluxDB or other outputs." \
      maintainer="collection@sumologic.com"

COPY --from=builder /usr/bin/telegraf \
    /usr/bin/telegraf
COPY --from=builder /etc/telegraf/telegraf.conf \
    /etc/telegraf/telegraf.conf
# copy ca-cerificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs

ADD https://raw.githubusercontent.com/influxdata/influxdata-docker/1d3c13915c892a46bca5da3e3369b8620be6df80/telegraf/LICENSE \
    /licenses/LICENSE

EXPOSE 8125/udp 8092/udp 8094

COPY --from=builder /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
