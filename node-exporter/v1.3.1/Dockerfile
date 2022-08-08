## Use original image to copy files from
## ref: https://github.com/prometheus/node_exporter/blob/a2321e7b940ddcff26873612bccdf7cd4c42b6b6/Dockerfile
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
ADD https://raw.githubusercontent.com/prometheus/node_exporter/3715be6ae899f2a9b9dbfd9c39f3e09a7bd4559f/LICENSE \
    /licenses/LICENSE

EXPOSE      9100
USER        nobody
ENTRYPOINT  [ "/bin/node_exporter" ]
