## Use original image to copy files from
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/b86ab77239f2a11ee69ad05b24122958d8b2df5b/cmd/prometheus-config-reloader/Dockerfile
FROM quay.io/prometheus-operator/prometheus-config-reloader:v0.43.2 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi:8.4

LABEL name="Prometheus-config-reloader" \
      vendor="SumoLogic" \
      version="0.43.2" \
      release="1" \
      summary="UBI based prometheus-config-reloader" \
      description="Prometheus configuration reloader" \
      maintainer="collection@sumologic.com"

COPY --from=builder \
    /bin/prometheus-config-reloader \
    /bin/prometheus-config-reloader
ADD https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/b86ab77239f2a11ee69ad05b24122958d8b2df5b/LICENSE \
    /licenses/LICENSE

USER nobody

ENTRYPOINT ["/bin/prometheus-config-reloader"]
