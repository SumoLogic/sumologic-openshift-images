## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/v0.44.0/cmd/prometheus-config-reloader/Dockerfile
FROM quay.io/prometheus-operator/prometheus-config-reloader:v0.44.0 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.6

LABEL name="Prometheus-config-reloader" \
      vendor="Sumo Logic" \
      version="0.44.0" \
      release="2" \
      summary="UBI based prometheus-config-reloader" \
      description="Prometheus configuration reloader" \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/prometheus-config-reloader \
    /bin/prometheus-config-reloader
ADD https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.44.0/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT ["/bin/prometheus-config-reloader"]
