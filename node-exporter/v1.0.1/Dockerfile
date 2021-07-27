## Use original image to copy files from
## ref: https://github.com/prometheus/node_exporter/blob/3715be6ae899f2a9b9dbfd9c39f3e09a7bd4559f/Dockerfile
FROM quay.io/prometheus/node-exporter:v1.0.1 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Node-exporter" \
      vendor="SumoLogic" \
      version="1.0.1" \
      release="1" \
      summary="UBI based node-exporter" \
      description="Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors." \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/node_exporter \
    /bin/node_exporter
ADD https://raw.githubusercontent.com/prometheus/node_exporter/3715be6ae899f2a9b9dbfd9c39f3e09a7bd4559f/LICENSE \
    /licenses/LICENSE

EXPOSE      9100
USER        nobody
ENTRYPOINT  [ "/bin/node_exporter" ]
