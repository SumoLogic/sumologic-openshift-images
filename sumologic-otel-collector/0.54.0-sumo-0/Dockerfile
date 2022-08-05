## Use original image to copy files from
## ref: https://github.com/SumoLogic/sumologic-otel-collector/blob/v0.54.0-sumo-0/Dockerfile
FROM public.ecr.aws/sumologic/sumologic-otel-collector:0.54.0-sumo-0 as builder

## Build RedHat compliant image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6

LABEL name="Opentelemetry-collector" \
      vendor="Sumo Logic" \
      version="0.54.0-sumo" \
      release="2" \
      summary="UBI based opentelemetry-collector" \
      description="The OpenTelemetry Collector offers a vendor-agnostic implementation on how to receive, process and export telemetry data." \
      maintainer="collection@sumologic.com"

ADD https://github.com/SumoLogic/sumologic-otel-collector/blob/v0.54.0-sumo-0/LICENSE \
    /licenses/LICENSE

ARG USER_UID=10001
USER ${USER_UID}
ENV HOME /etc/otel/

# copy journalctl and it's dependencies as base structure
COPY --from=builder / /
COPY --from=builder --chown=${USER_UID}:${USER_UID} /etc/otel/ /etc/otel/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /otelcol-sumo /otelcol-sumo
ENTRYPOINT ["/otelcol-sumo"]
CMD ["--config", "/etc/otel/config.yaml"]
