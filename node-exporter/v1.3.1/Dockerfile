## Use original image to copy files from
## ref: https://github.com/prometheus/node_exporter/blob/v1.3.1/Dockerfile
FROM quay.io/prometheus/node-exporter:v1.3.1 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

LABEL name="Node-exporter" \
      vendor="Sumo Logic" \
      version="1.3.1" \
      release="2" \
      summary="UBI based node-exporter" \
      description="Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors." \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/node_exporter \
    /bin/node_exporter
ADD https://raw.githubusercontent.com/prometheus/node_exporter/v1.3.1/LICENSE \
    /licenses/LICENSE

EXPOSE      9100
USER        nobody
ENTRYPOINT  [ "/bin/node_exporter" ]
